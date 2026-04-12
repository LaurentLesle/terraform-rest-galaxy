output "id" {
  description = "The full ARM resource ID of the Application Insights component (plan-time known)."
  value       = local.appi_path
}

output "name" {
  description = "The name of the Application Insights component (plan-time, echoes input)."
  value       = var.application_insights_name
}

output "location" {
  description = "The location of the Application Insights component (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "api_version" {
  description = "The ARM API version used to manage this Application Insights component."
  value       = local.api_version
}

output "provisioning_state" {
  description = "The provisioning state of the Application Insights component."
  value       = try(rest_resource.application_insights.output.properties.provisioningState, null)
}

output "instrumentation_key" {
  description = "Application Insights Instrumentation key. Used to identify the telemetry destination. Treat as a secret — do not log or expose in outputs."
  value       = try(rest_resource.application_insights.output.properties.InstrumentationKey, null)
}

output "connection_string" {
  description = "Application Insights component connection string. Treat as a secret — do not log or expose in outputs."
  value       = try(rest_resource.application_insights.output.properties.ConnectionString, null)
}

output "app_id" {
  description = "Application Insights Unique ID for your Application."
  value       = try(rest_resource.application_insights.output.properties.AppId, null)
}

output "application_id" {
  description = "The unique ID of the application (mirrors the Name field)."
  value       = try(rest_resource.application_insights.output.properties.ApplicationId, null)
}
