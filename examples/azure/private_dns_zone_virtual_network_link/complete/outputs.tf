output "azure_private_dns_zone_virtual_network_links" {
  description = "Map of Private DNS Zone Virtual Network Link outputs from the root module, keyed by instance name."
  value       = module.root.azure_values.azure_private_dns_zone_virtual_network_links
}
