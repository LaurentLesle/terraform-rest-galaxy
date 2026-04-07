output "id" {
  description = "The full ARM resource ID of the Email Communication Service."
  value       = local.ecs_path
}

output "api_version" {
  description = "The ARM API version used to manage this Email Communication Service."
  value       = "2026-03-18"
}

output "name" {
  description = "The name of the Email Communication Service (plan-time, echoes input)."
  value       = var.email_service_name
}

output "location" {
  description = "The location of the Email Communication Service (plan-time, echoes input)."
  value       = var.location
}

output "data_location" {
  description = "The data location of the Email Communication Service (plan-time, echoes input)."
  value       = var.data_location
}

output "provisioning_state" {
  description = "The provisioning state of the Email Communication Service."
  value       = try(rest_resource.email_communication_service.output.properties.provisioningState, null)
}
