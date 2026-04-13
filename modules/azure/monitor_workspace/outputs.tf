output "id" {
  description = "The full ARM resource ID of the Azure Monitor Workspace (plan-time, built from inputs)."
  value       = local.amw_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the Azure Monitor Workspace (plan-time, echoes input)."
  value       = var.monitor_workspace_name
}

output "location" {
  description = "The location of the Azure Monitor Workspace (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags of the Azure Monitor Workspace (plan-time, echoes input)."
  value       = var.tags
}

output "provisioning_state" {
  description = "The provisioning state of the Azure Monitor Workspace."
  value       = try(rest_resource.monitor_workspace.output.properties.provisioningState, null)
}

output "metrics_ingestion_endpoint" {
  description = "The Prometheus query endpoint for the Azure Monitor Workspace (known after apply)."
  value       = try(rest_resource.monitor_workspace.output.properties.metrics.prometheusQueryEndpoint, null)
}

output "query_endpoint" {
  description = "The Prometheus query endpoint (alias for metrics_ingestion_endpoint)."
  value       = try(rest_resource.monitor_workspace.output.properties.metrics.prometheusQueryEndpoint, null)
}

output "default_data_collection_rule_id" {
  description = "The resource ID of the default Data Collection Rule (known after apply)."
  value       = try(rest_resource.monitor_workspace.output.properties.defaultIngestionSettings.dataCollectionRuleResourceId, null)
}

output "default_data_collection_endpoint_id" {
  description = "The resource ID of the default Data Collection Endpoint (known after apply)."
  value       = try(rest_resource.monitor_workspace.output.properties.defaultIngestionSettings.dataCollectionEndpointResourceId, null)
}
