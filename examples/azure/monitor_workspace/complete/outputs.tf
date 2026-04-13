output "azure_monitor_workspaces" {
  description = "Map of Azure Monitor Workspace outputs from the root module."
  value       = module.root.azure_values.azure_monitor_workspaces
}
