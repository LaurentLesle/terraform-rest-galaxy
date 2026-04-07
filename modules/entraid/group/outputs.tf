# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "display_name" {
  description = "The display name of the group (plan-time, echoes input)."
  value       = var.display_name
}

output "mail_nickname" {
  description = "The mail alias for the group (plan-time, echoes input)."
  value       = var.mail_nickname
}

output "security_enabled" {
  description = "Whether the group is a security group (plan-time, echoes input)."
  value       = var.security_enabled
}

output "mail_enabled" {
  description = "Whether the group is mail-enabled (plan-time, echoes input)."
  value       = var.mail_enabled
}

# ── Known after apply (server-assigned) ───────────────────────────────────────

output "id" {
  description = "The unique identifier (object ID) of the group, assigned by Azure AD."
  value       = try(rest_resource.group.output.id, null)
}

output "created_date_time" {
  description = "The date and time the group was created (ISO 8601 UTC)."
  value       = try(rest_resource.group.output.createdDateTime, null)
}
