output "azure_virtual_network_gateways" {
  description = "Map of virtual network gateway outputs from the root module."
  value       = module.root.azure_values.azure_virtual_network_gateways
}
