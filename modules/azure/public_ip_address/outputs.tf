output "id" {
  description = "The full ARM resource ID of the public IP address."
  value       = local.pip_path
}

output "name" {
  description = "The name of the public IP address."
  value       = var.public_ip_address_name
}

output "location" {
  description = "The location."
  value       = var.location
}

output "ip_address" {
  description = "The allocated IP address."
  value       = try(rest_resource.public_ip_address.output.properties.ipAddress, null)
}
