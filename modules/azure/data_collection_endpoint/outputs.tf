output "id" {
  description = "The full ARM resource ID of the Data Collection Endpoint (plan-time, built from inputs)."
  value       = local.dce_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the Data Collection Endpoint (plan-time, echoes input)."
  value       = var.data_collection_endpoint_name
}

output "location" {
  description = "The location of the Data Collection Endpoint (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags of the Data Collection Endpoint (plan-time, echoes input)."
  value       = var.tags
}

output "provisioning_state" {
  description = "The provisioning state of the Data Collection Endpoint."
  value       = try(rest_resource.data_collection_endpoint.output.properties.provisioningState, null)
}

output "logs_ingestion_endpoint" {
  description = "The logs ingestion endpoint URL (known after apply)."
  value       = try(rest_resource.data_collection_endpoint.output.properties.logsIngestion.endpoint, null)
}

output "metrics_ingestion_endpoint" {
  description = "The metrics ingestion endpoint URL (known after apply)."
  value       = try(rest_resource.data_collection_endpoint.output.properties.metricsIngestion.endpoint, null)
}

output "configuration_access_endpoint" {
  description = "The configuration access endpoint URL (known after apply)."
  value       = try(rest_resource.data_collection_endpoint.output.properties.configurationAccess.endpoint, null)
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity (known after apply)."
  value       = try(rest_resource.data_collection_endpoint.output.identity.principalId, null)
}

output "tenant_id" {
  description = "The tenant ID of the system-assigned managed identity (known after apply)."
  value       = try(rest_resource.data_collection_endpoint.output.identity.tenantId, null)
}
