output "azure_monitor_private_link_scopes" {
  description = "Map of Azure Monitor Private Link Scope outputs from the root module, keyed by instance name."
  value       = module.root.azure_values.azure_monitor_private_link_scopes
}
