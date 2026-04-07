output "azure_express_route_ports" {
  description = "Map of express route port outputs from the root module."
  value       = module.root.azure_values.azure_express_route_ports
}
