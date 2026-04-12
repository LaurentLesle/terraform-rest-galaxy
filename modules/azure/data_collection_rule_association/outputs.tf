output "id" {
  description = "The full ARM resource ID of the Data Collection Rule Association (plan-time, built from inputs)."
  value       = local.dcra_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the association (plan-time, echoes input)."
  value       = var.association_name
}

output "provisioning_state" {
  description = "The provisioning state of the Data Collection Rule Association."
  value       = try(rest_resource.data_collection_rule_association.output.properties.provisioningState, null)
}
