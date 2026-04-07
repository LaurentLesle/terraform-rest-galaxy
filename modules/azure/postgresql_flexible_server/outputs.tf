output "id" {
  description = "The full ARM resource ID of the PostgreSQL Flexible Server."
  value       = local.server_path
}

output "name" {
  description = "The server name (plan-time, echoes input)."
  value       = var.server_name
}

output "location" {
  description = "The location (plan-time, echoes input)."
  value       = var.location
}

output "fqdn" {
  description = "The fully qualified domain name of the server."
  value       = try(rest_resource.postgresql_flexible_server.output.properties.fullyQualifiedDomainName, null)
}

output "state" {
  description = "The state of the server (e.g. Ready)."
  value       = try(rest_resource.postgresql_flexible_server.output.properties.state, null)
}

output "version" {
  description = "The PostgreSQL version."
  value       = try(rest_resource.postgresql_flexible_server.output.properties.version, null)
}
