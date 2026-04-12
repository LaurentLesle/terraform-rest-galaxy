output "id" {
  description = "The full ARM resource ID of the Activity Log Alert rule (plan-time known)."
  value       = local.ala_path
}

output "name" {
  description = "The name of the Activity Log Alert rule (plan-time, echoes input)."
  value       = var.activity_log_alert_name
}

output "location" {
  description = "The location of the Activity Log Alert rule (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "api_version" {
  description = "The ARM API version used to manage this Activity Log Alert rule."
  value       = local.api_version
}

output "enabled" {
  description = "Whether the Activity Log Alert rule is enabled (plan-time, echoes input)."
  value       = var.enabled
}

output "provisioning_state" {
  description = "The provisioning state of the Activity Log Alert rule."
  value       = try(rest_resource.activity_log_alert.output.properties.provisioningState, null)
}
