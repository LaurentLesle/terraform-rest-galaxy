# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "display_name" {
  description = "The display name of the user (plan-time, echoes input)."
  value       = var.display_name
}

output "user_principal_name" {
  description = "The UPN of the user (plan-time, echoes input)."
  value       = var.user_principal_name
}

output "mail_nickname" {
  description = "The mail alias for the user (plan-time, echoes input)."
  value       = var.mail_nickname
}

output "account_enabled" {
  description = "Whether the account is enabled (plan-time, echoes input)."
  value       = var.account_enabled
}

# ── Known after apply (server-assigned) ───────────────────────────────────────

output "id" {
  description = "The unique identifier (object ID) of the user, assigned by Azure AD."
  value       = try(rest_resource.user.output.id, null)
}

output "created_date_time" {
  description = "The date and time the user was created (ISO 8601 UTC)."
  value       = try(rest_resource.user.output.createdDateTime, null)
}
