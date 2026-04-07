output "azure_route_tables" {
  description = "Map of route table outputs from the root module."
  value       = module.root.azure_values.azure_route_tables
}
