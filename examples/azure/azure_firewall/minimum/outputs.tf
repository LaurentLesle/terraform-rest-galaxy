output "azure_firewalls" {
  description = "Map of azure firewall outputs from the root module."
  value       = module.root.azure_values.azure_firewalls
}
