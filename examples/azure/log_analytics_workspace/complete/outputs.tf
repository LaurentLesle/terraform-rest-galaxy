output "azure_log_analytics_workspaces" {
  description = "Map of Log Analytics Workspace outputs from the root module."
  value       = module.root.azure_values.azure_log_analytics_workspaces
}
