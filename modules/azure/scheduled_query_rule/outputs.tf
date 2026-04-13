output "id" {
  description = "The full ARM resource ID of the scheduled query rule (plan-time known)."
  value       = local.sqr_path
}

output "name" {
  description = "The name of the scheduled query rule (plan-time, echoes input)."
  value       = var.rule_name
}

output "location" {
  description = "The location of the scheduled query rule (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "api_version" {
  description = "The ARM API version used to manage this scheduled query rule."
  value       = local.api_version
}

output "enabled" {
  description = "Whether the scheduled query rule is enabled (plan-time, echoes input)."
  value       = var.enabled
}

output "severity" {
  description = "The severity of the rule (plan-time, echoes input)."
  value       = var.severity
}

output "provisioning_state" {
  description = "The provisioning state of the scheduled query rule."
  value       = try(rest_resource.scheduled_query_rule.output.properties.provisioningState, null)
}

output "created_with_api_version" {
  description = "The api-version used when creating this alert rule."
  value       = try(rest_resource.scheduled_query_rule.output.properties.createdWithApiVersion, null)
}

output "is_workspace_alerts_storage_configured" {
  description = "Whether the rule is configured to be stored in customer's storage."
  value       = try(rest_resource.scheduled_query_rule.output.properties.isWorkspaceAlertsStorageConfigured, null)
}
