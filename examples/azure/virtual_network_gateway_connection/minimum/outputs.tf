output "azure_virtual_network_gateway_connections" {
  description = "Map of virtual network gateway connection outputs from the root module."
  value       = module.root.azure_values.azure_virtual_network_gateway_connections
}
