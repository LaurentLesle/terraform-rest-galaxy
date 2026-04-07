output "azure_private_dns_zones" {
  description = "Map of private dns zone outputs from the root module."
  value       = module.root.azure_values.azure_private_dns_zones
}
