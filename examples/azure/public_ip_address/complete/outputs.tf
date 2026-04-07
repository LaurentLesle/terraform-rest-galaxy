output "azure_public_ip_addresses" {
  description = "Map of public ip address outputs from the root module."
  value       = module.root.azure_values.azure_public_ip_addresses
}
