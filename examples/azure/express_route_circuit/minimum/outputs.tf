output "azure_express_route_circuits" {
  description = "Map of express route circuit outputs from the root module."
  value       = module.root.azure_values.azure_express_route_circuits
}
