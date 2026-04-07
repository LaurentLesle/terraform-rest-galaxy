output "azure_routing_intents" {
  description = "Map of routing intent outputs from the root module."
  value       = module.root.azure_values.azure_routing_intents
}
