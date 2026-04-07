output "id" {
  description = "The full ARM resource ID of the administrator."
  value       = local.admin_path
}

output "object_id" {
  description = "The object ID of the Entra principal."
  value       = var.object_id
}

output "principal_name" {
  description = "The display name of the Entra principal."
  value       = var.principal_name
}

output "principal_type" {
  description = "The type of Entra principal."
  value       = var.principal_type
}
