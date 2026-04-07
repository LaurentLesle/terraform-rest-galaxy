output "azure_vpn_gateways" {
  description = "Map of vpn gateway outputs from the root module."
  value       = module.root.azure_values.azure_vpn_gateways
}
