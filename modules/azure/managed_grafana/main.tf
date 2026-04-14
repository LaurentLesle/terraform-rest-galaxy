# Source: azure-rest-api-specs
#   spec_path  : dashboard/resource-manager/Microsoft.Dashboard/stable/2025-08-01/grafana.json
#   api_version: 2025-08-01
#   stability  : stable
#   operation  : Grafana_Create (PUT, long-running — Azure-AsyncOperation header)
#   delete     : Grafana_Delete (DELETE, long-running — Azure-AsyncOperation header)

locals {
  api_version  = "2025-08-01"
  grafana_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Dashboard/grafana/${var.grafana_name}"

  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  ) : null

  grafana_integrations = var.azure_monitor_workspace_integrations != null ? {
    azureMonitorWorkspaceIntegrations = [
      for i in var.azure_monitor_workspace_integrations : {
        azureMonitorWorkspaceResourceId = i.azure_monitor_workspace_resource_id
      }
    ]
  } : null

  smtp_config = var.grafana_configurations_smtp != null ? {
    for k, v in {
      enabled        = var.grafana_configurations_smtp.enabled
      host           = var.grafana_configurations_smtp.host
      user           = var.grafana_configurations_smtp.user
      password       = var.grafana_configurations_smtp.password
      fromAddress    = var.grafana_configurations_smtp.from_address
      fromName       = var.grafana_configurations_smtp.from_name
      startTLSPolicy = var.grafana_configurations_smtp.start_tls_policy
      skipVerify     = var.grafana_configurations_smtp.skip_verify
    } : k => v if v != null
  } : null

  grafana_configurations = merge(
    local.smtp_config != null ? { smtp = local.smtp_config } : {},
    var.grafana_configurations_snapshots_external_enabled != null ? {
      snapshots = { externalEnabled = var.grafana_configurations_snapshots_external_enabled }
    } : {},
    var.grafana_configurations_users_viewers_can_edit != null || var.grafana_configurations_users_editors_can_admin != null ? {
      users = merge(
        var.grafana_configurations_users_viewers_can_edit != null ? { viewersCanEdit = var.grafana_configurations_users_viewers_can_edit } : {},
        var.grafana_configurations_users_editors_can_admin != null ? { editorsCanAdmin = var.grafana_configurations_users_editors_can_admin } : {},
      )
    } : {},
  )

  enterprise_configurations = var.enterprise_marketplace_plan_id != null || var.enterprise_marketplace_auto_renew != null ? merge(
    var.enterprise_marketplace_plan_id != null ? { marketplacePlanId = var.enterprise_marketplace_plan_id } : {},
    var.enterprise_marketplace_auto_renew != null ? { marketplaceAutoRenew = var.enterprise_marketplace_auto_renew } : {},
  ) : null

  properties = merge(
    { publicNetworkAccess = var.public_network_access },
    { zoneRedundancy = var.zone_redundancy },
    { apiKey = var.api_key },
    { deterministicOutboundIP = var.deterministic_outbound_ip },
    var.creator_can_admin != null ? { creatorCanAdmin = var.creator_can_admin } : {},
    var.grafana_major_version != null ? { grafanaMajorVersion = var.grafana_major_version } : {},
    local.grafana_integrations != null ? { grafanaIntegrations = local.grafana_integrations } : {},
    length(local.grafana_configurations) > 0 ? { grafanaConfigurations = local.grafana_configurations } : {},
    local.enterprise_configurations != null ? { enterpriseConfigurations = local.enterprise_configurations } : {},
    var.grafana_plugins != null ? { grafanaPlugins = var.grafana_plugins } : {},
  )

  body = merge(
    { location = var.location },
    { sku = { name = var.sku_name } },
    { properties = local.properties },
    local.identity != null ? { identity = local.identity } : {},
    var.tags != null ? { tags = var.tags } : {},
  )
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Dashboard"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "managed_grafana" {
  path            = local.grafana_path
  create_method   = "PUT"
  check_existance = var.check_existance

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Dashboard is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    dashboard:\n      resource_provider_namespace: Microsoft.Dashboard"
    }
  }


  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.endpoint",
    "properties.grafanaVersion",
  ])

  # PUT is long-running with Azure-AsyncOperation header.
  poll_create = {
    status_locator    = "body.status"
    url_locator       = "header.Azure-AsyncOperation"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Creating", "Updating", "Accepted", "Running", "InProgress"]
    }
  }

  poll_update = {
    status_locator    = "body.status"
    url_locator       = "header.Azure-AsyncOperation"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Accepted", "Running", "InProgress"]
    }
  }

  # DELETE is async — polls until resource returns 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }
}
