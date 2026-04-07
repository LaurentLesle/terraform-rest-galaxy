output "azure_firewall_policies" {
  description = "Map of firewall policy outputs from the root module."
  value       = module.root.azure_values.azure_firewall_policies
}
