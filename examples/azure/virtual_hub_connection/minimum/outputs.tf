output "azure_virtual_hub_connections" {
  description = "Map of virtual hub connection outputs from the root module."
  value       = module.root.azure_values.azure_virtual_hub_connections
}
