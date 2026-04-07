# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "resource_provider_namespace" {
  description = "The resource provider namespace (echoes input)."
  value       = var.resource_provider_namespace
}

output "subscription_id" {
  description = "The subscription ID where the provider is registered (echoes input)."
  value       = var.subscription_id
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "registration_state" {
  description = "The registration state of the resource provider (e.g. Registered, Registering)."
  value       = try(rest_operation.register.output.registrationState, null)
}
