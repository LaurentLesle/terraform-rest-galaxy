output "id" {
  description = "The full ARM resource ID of the route table."
  value       = local.rt_path
}

output "name" {
  description = "The name of the route table."
  value       = var.route_table_name
}

output "location" {
  description = "The location."
  value       = var.location
}
