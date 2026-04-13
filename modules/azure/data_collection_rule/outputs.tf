output "id" {
  description = "The full ARM resource ID of the Data Collection Rule (plan-time, built from inputs)."
  value       = local.dcr_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the Data Collection Rule (plan-time, echoes input)."
  value       = var.data_collection_rule_name
}

output "location" {
  description = "The location of the Data Collection Rule (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags of the Data Collection Rule (plan-time, echoes input)."
  value       = var.tags
}

output "provisioning_state" {
  description = "The provisioning state of the Data Collection Rule."
  value       = try(rest_resource.data_collection_rule.output.properties.provisioningState, null)
}

output "immutable_id" {
  description = "The immutable ID of the Data Collection Rule (known after apply)."
  value       = try(rest_resource.data_collection_rule.output.properties.immutableId, null)
}
