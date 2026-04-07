output "id" {
  description = "The object ID of the service principal."
  value       = rest_resource.service_principal.output.id
}

output "app_id" {
  description = "The application (client) ID."
  value       = rest_resource.service_principal.output.appId
}

output "display_name" {
  description = "The display name of the service principal."
  value       = rest_resource.service_principal.output.displayName
}
