output "id" {
  description = "The full ARM resource ID of the blob container."
  value       = local.container_path
}

output "name" {
  description = "The container name (echoes input)."
  value       = var.container_name
}
