output "id" {
  description = "The full ARM resource ID of the management group."
  value       = local.mg_path
}

output "name" {
  description = "The management group ID (last segment of the ARM path)."
  value       = var.management_group_id
}

output "display_name" {
  description = "The display name of the management group."
  value       = try(rest_resource.management_group.output.properties.displayName, var.display_name)
}

output "tenant_id" {
  description = "The tenant ID the management group belongs to."
  value       = try(rest_resource.management_group.output.properties.tenantId, null)
}

output "parent_id" {
  description = "The full ARM resource ID of the parent management group."
  value       = try(rest_resource.management_group.output.properties.details.parent.id, var.parent_id)
}
