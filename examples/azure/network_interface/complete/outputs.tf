output "azure_network_interfaces" {
  description = "Map of network interface outputs from the root module."
  value       = module.root.azure_values.azure_network_interfaces
}
