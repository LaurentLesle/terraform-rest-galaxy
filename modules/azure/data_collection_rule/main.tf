# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights/stable/2024-03-11/dataCollectionRules_API.json
#   api_version: 2024-03-11
#   stability  : stable
#   operation  : DataCollectionRules_Create (PUT, synchronous — 200/201)
#   delete     : DataCollectionRules_Delete (DELETE, synchronous — 200/204)

locals {
  api_version = "2024-03-11"
  dcr_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${var.data_collection_rule_name}"

  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  ) : null

  data_flows_normalized = var.data_flows != null ? [
    for df in var.data_flows : merge(
      { streams = df.streams },
      { destinations = df.destinations },
      df.transform_kql != null ? { transformKql = df.transform_kql } : {},
      df.output_stream != null ? { outputStream = df.output_stream } : {},
      df.built_in_transform != null ? { builtInTransform = df.built_in_transform } : {},
    )
  ] : null

  stream_declarations_normalized = var.stream_declarations != null ? {
    for k, v in var.stream_declarations : k => v
  } : null

  properties = merge(
    var.description != null ? { description = var.description } : {},
    var.data_collection_endpoint_id != null ? { dataCollectionEndpointId = var.data_collection_endpoint_id } : {},
    local.stream_declarations_normalized != null ? { streamDeclarations = local.stream_declarations_normalized } : {},
    var.data_sources != null ? { dataSources = var.data_sources } : {},
    var.direct_data_sources != null ? { directDataSources = var.direct_data_sources } : {},
    var.destinations != null ? { destinations = var.destinations } : {},
    local.data_flows_normalized != null ? { dataFlows = local.data_flows_normalized } : {},
    var.references != null ? { references = var.references } : {},
    var.agent_settings != null ? { agentSettings = var.agent_settings } : {},
  )

  body = merge(
    { location = var.location },
    { properties = local.properties },
    var.kind != null ? { kind = var.kind } : {},
    local.identity != null ? { identity = local.identity } : {},
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "data_collection_rule" {
  path            = local.dcr_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.immutableId",
  ])

  # PUT is synchronous (200/201) — no polling needed.
}
