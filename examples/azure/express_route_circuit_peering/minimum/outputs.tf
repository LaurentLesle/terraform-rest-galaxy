output "azure_express_route_circuit_peerings" {
  description = "Map of express route circuit peering outputs from the root module."
  value       = module.root.azure_values.azure_express_route_circuit_peerings
}
