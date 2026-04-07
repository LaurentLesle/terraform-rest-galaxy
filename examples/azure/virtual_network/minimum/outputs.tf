output "azure_virtual_networks" {
  description = "Map of virtual network outputs from the root module."
  value       = module.root.azure_values.azure_virtual_networks
}
