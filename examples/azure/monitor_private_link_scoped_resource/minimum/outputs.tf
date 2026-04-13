output "azure_monitor_private_link_scoped_resources" {
  description = "Map of Azure Monitor Private Link Scoped Resource outputs from the root module, keyed by instance name."
  value       = module.root.azure_values.azure_monitor_private_link_scoped_resources
}
