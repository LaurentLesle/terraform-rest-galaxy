# Source: azure-rest-api-specs
#   spec_path  : applicationinsights/resource-manager/Microsoft.Insights/ApplicationInsights
#   api_version: 2020-02-02
#   swagger    : components_API.json
#   operation  : Components_CreateOrUpdate (PUT, synchronous)
#   delete     : Components_Delete (DELETE, synchronous)

locals {
  api_version = "2020-02-02"
  appi_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/components/${var.application_insights_name}"

  properties = merge(
    {
      Application_Type = var.application_type
    },
    var.flow_type != null ? { Flow_Type = var.flow_type } : {},
    var.request_source != null ? { Request_Source = var.request_source } : {},
    var.retention_in_days != null ? { RetentionInDays = var.retention_in_days } : {},
    var.sampling_percentage != null ? { SamplingPercentage = var.sampling_percentage } : {},
    var.disable_ip_masking != null ? { DisableIpMasking = var.disable_ip_masking } : {},
    var.immediate_purge_data_on30_days != null ? { ImmediatePurgeDataOn30Days = var.immediate_purge_data_on30_days } : {},
    var.workspace_resource_id != null ? { WorkspaceResourceId = var.workspace_resource_id } : {},
    var.hockey_app_id != null ? { HockeyAppId = var.hockey_app_id } : {},
    var.public_network_access_for_ingestion != null ? { publicNetworkAccessForIngestion = var.public_network_access_for_ingestion } : {},
    var.public_network_access_for_query != null ? { publicNetworkAccessForQuery = var.public_network_access_for_query } : {},
    var.ingestion_mode != null ? { IngestionMode = var.ingestion_mode } : {},
    var.disable_local_auth != null ? { DisableLocalAuth = var.disable_local_auth } : {},
    var.force_customer_storage_for_profiler != null ? { ForceCustomerStorageForProfiler = var.force_customer_storage_for_profiler } : {},
  )

  body = merge(
    {
      location   = var.location
      kind       = var.kind
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
    var.etag != null ? { etag = var.etag } : {},
  )
}

resource "rest_resource" "application_insights" {
  path            = local.appi_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.InstrumentationKey",
    "properties.ConnectionString",
    "properties.AppId",
    "properties.ApplicationId",
  ])

  # PUT and DELETE are synchronous — no polling needed.
}
