# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights/stable/2024-03-11/dataCollectionEndpoints_API.json
#   api_version: 2024-03-11
#   stability  : stable
#   operation  : DataCollectionEndpoints_Create (PUT, synchronous — 200/201, no LRO)
#   delete     : DataCollectionEndpoints_Delete (DELETE, synchronous — 200/204)

locals {
  api_version = "2024-03-11"
  dce_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/dataCollectionEndpoints/${var.data_collection_endpoint_name}"

  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  ) : null

  properties = merge(
    var.description != null ? { description = var.description } : {},
    { networkAcls = { publicNetworkAccess = var.public_network_access } },
  )

  body = merge(
    { location = var.location },
    { properties = local.properties },
    var.kind != null ? { kind = var.kind } : {},
    local.identity != null ? { identity = local.identity } : {},
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "data_collection_endpoint" {
  path            = local.dce_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.logsIngestion.endpoint",
    "properties.metricsIngestion.endpoint",
    "properties.configurationAccess.endpoint",
    "identity.principalId",
    "identity.tenantId",
  ])

  # PUT is synchronous (200/201) — no polling needed.
}
