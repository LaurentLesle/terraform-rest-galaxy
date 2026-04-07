output "id" {
  description = "The full ARM resource ID of the Communication Service."
  value       = local.acs_path
}

output "api_version" {
  description = "The ARM API version used to manage this Communication Service."
  value       = "2026-03-18"
}

output "name" {
  description = "The name of the Communication Service (plan-time, echoes input)."
  value       = var.communication_service_name
}

output "location" {
  description = "The location of the Communication Service (plan-time, echoes input)."
  value       = var.location
}

output "data_location" {
  description = "The data location of the Communication Service (plan-time, echoes input)."
  value       = var.data_location
}

output "provisioning_state" {
  description = "The provisioning state of the Communication Service."
  value       = try(rest_resource.communication_service.output.properties.provisioningState, null)
}

output "host_name" {
  description = "FQDN of the Communication Service instance."
  value       = try(rest_resource.communication_service.output.properties.hostName, null)
}

output "immutable_resource_id" {
  description = "The immutable resource ID of the Communication Service."
  value       = try(rest_resource.communication_service.output.properties.immutableResourceId, null)
}
