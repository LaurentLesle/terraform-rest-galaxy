output "id" {
  description = "The full ARM resource ID of the ExpressRoute circuit."
  value       = local.erc_path
}

output "name" {
  description = "The name of the ExpressRoute circuit."
  value       = var.circuit_name
}

output "location" {
  description = "The location."
  value       = var.location
}

output "service_key" {
  description = "The service key."
  value       = try(rest_resource.express_route_circuit.output.properties.serviceKey, null)
}
