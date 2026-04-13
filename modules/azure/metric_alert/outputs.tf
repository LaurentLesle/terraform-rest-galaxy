output "id" {
  description = "The full ARM resource ID of the metric alert (plan-time known)."
  value       = local.ma_path
}

output "name" {
  description = "The name of the metric alert (plan-time, echoes input)."
  value       = var.metric_alert_name
}

output "location" {
  description = "The location of the metric alert (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "api_version" {
  description = "The ARM API version used to manage this metric alert."
  value       = local.api_version
}

output "enabled" {
  description = "Whether the metric alert is enabled (plan-time, echoes input)."
  value       = var.enabled
}

output "severity" {
  description = "The severity of the metric alert (plan-time, echoes input)."
  value       = var.severity
}

output "provisioning_state" {
  description = "The provisioning state of the metric alert."
  value       = try(rest_resource.metric_alert.output.properties.provisioningState, null)
}

output "last_updated_time" {
  description = "Last time the rule was updated (ISO8601 format)."
  value       = try(rest_resource.metric_alert.output.properties.lastUpdatedTime, null)
}
