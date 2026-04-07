output "azure_virtual_hubs" {
  description = "Map of virtual hub outputs from the root module."
  value       = module.root.azure_values.azure_virtual_hubs
}
