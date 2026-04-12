output "id" {
  description = "The full ARM resource ID of the alert processing rule (plan-time known)."
  value       = local.apr_path
}

output "name" {
  description = "The name of the alert processing rule (plan-time, echoes input)."
  value       = var.alert_processing_rule_name
}

output "location" {
  description = "The location of the alert processing rule (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "api_version" {
  description = "The ARM API version used to manage this alert processing rule."
  value       = local.api_version
}

output "enabled" {
  description = "Whether the alert processing rule is enabled (plan-time, echoes input)."
  value       = var.enabled
}

output "provisioning_state" {
  description = "The provisioning state of the alert processing rule."
  value       = try(rest_resource.alert_processing_rule.output.properties.provisioningState, null)
}
