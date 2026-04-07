# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "display_name" {
  description = "The display name of the application (plan-time, echoes input)."
  value       = var.display_name
}

output "sign_in_audience" {
  description = "The sign-in audience (plan-time, echoes input)."
  value       = var.sign_in_audience
}

# ── Known after apply (server-assigned) ───────────────────────────────────────

output "id" {
  description = "The unique identifier (object ID) of the application, assigned by Azure AD."
  value       = try(rest_resource.application.output.id, null)
}

output "app_id" {
  description = "The application (client) ID assigned by Azure AD."
  value       = try(rest_resource.application.output.appId, null)
}

output "publisher_domain" {
  description = "The verified publisher domain for the application."
  value       = try(rest_resource.application.output.publisherDomain, null)
}

output "created_date_time" {
  description = "The date and time the application was registered (ISO 8601 UTC)."
  value       = try(rest_resource.application.output.createdDateTime, null)
}

output "identifier_uris" {
  description = "The identifier URIs for the application."
  value       = try(rest_resource.application.output.identifierUris, null)
}
