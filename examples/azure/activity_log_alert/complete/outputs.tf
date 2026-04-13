output "azure_activity_log_alerts" {
  description = "Map of Activity Log Alert outputs from the root module."
  value       = module.root.azure_values.azure_activity_log_alerts
}
