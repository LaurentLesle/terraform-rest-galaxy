# Source: azure-rest-api-specs
#   spec_path  : operationalinsights/resource-manager/Microsoft.OperationalInsights/OperationalInsights/stable/2025-07-01/Workspaces.json
#   api_version: 2025-07-01
#   stability  : stable
#   operation  : Workspaces_CreateOrUpdate (PUT, long-running)
#   delete     : Workspaces_Delete (DELETE, long-running)

locals {
  api_version = "2025-07-01"
  law_path    = "/subscriptions/${var.subscription_id}/resourcegroups/${var.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${var.workspace_name}"

  sku = var.sku_capacity_reservation_level != null ? {
    name                     = var.sku_name
    capacityReservationLevel = var.sku_capacity_reservation_level
    } : {
    name = var.sku_name
  }

  workspace_capping = var.daily_quota_gb != null ? {
    dailyQuotaGb = var.daily_quota_gb
  } : null

  features = merge(
    var.features_enable_data_export != null ? { enableDataExport = var.features_enable_data_export } : {},
    var.features_immediate_purge_data_on_30_days != null ? { immediatePurgeDataOn30Days = var.features_immediate_purge_data_on_30_days } : {},
    var.features_enable_log_access_using_only_resource_permissions != null ? { enableLogAccessUsingOnlyResourcePermissions = var.features_enable_log_access_using_only_resource_permissions } : {},
    var.features_cluster_resource_id != null ? { clusterResourceId = var.features_cluster_resource_id } : {},
    var.features_disable_local_auth != null ? { disableLocalAuth = var.features_disable_local_auth } : {},
  )

  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  ) : null

  replication = var.replication_enabled != null ? merge(
    { enabled = var.replication_enabled },
    var.replication_location != null ? { location = var.replication_location } : {},
  ) : null

  properties = merge(
    { sku = local.sku },
    { publicNetworkAccessForIngestion = var.public_network_access_for_ingestion },
    { publicNetworkAccessForQuery = var.public_network_access_for_query },
    local.workspace_capping != null ? { workspaceCapping = local.workspace_capping } : {},
    var.retention_in_days != null ? { retentionInDays = var.retention_in_days } : {},
    var.force_cmk_for_query != null ? { forceCmkForQuery = var.force_cmk_for_query } : {},
    length(local.features) > 0 ? { features = local.features } : {},
    var.default_data_collection_rule_resource_id != null ? { defaultDataCollectionRuleResourceId = var.default_data_collection_rule_resource_id } : {},
    local.replication != null ? { replication = local.replication } : {},
  )

  body = merge(
    { location = var.location },
    { properties = local.properties },
    local.identity != null ? { identity = local.identity } : {},
    var.tags != null ? { tags = var.tags } : {},
  )
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.OperationalInsights"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "log_analytics_workspace" {
  path            = local.law_path
  create_method   = "PUT"
  check_existance = var.check_existance

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.OperationalInsights is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    operational_insights:\n      resource_provider_namespace: Microsoft.OperationalInsights"
    }
  }


  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.customerId",
    "identity.principalId",
    "identity.tenantId",
  ])

  # replication.location is immutable once set — changing it requires destroy + recreate.
  force_new_attrs = toset([
    "properties.replication.location",
  ])

  # PUT is long-running — uses provisioningState polling (no async header in spec).
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating", "Provisioning", "Accepted", "ProvisioningAccount"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning", "Accepted"]
    }
  }

  # DELETE is async — polls until resource returns 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = "404"
      pending = ["202", "200"]
    }
  }
}
