output "azure_load_balancers" {
  description = "Map of load balancer outputs from the root module."
  value       = module.root.azure_values.azure_load_balancers
}
