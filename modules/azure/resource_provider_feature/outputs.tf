# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the feature registration."
  value       = local.feature_path
}

output "provider_namespace" {
  description = "The resource provider namespace (echoes input)."
  value       = var.provider_namespace
}

output "feature_name" {
  description = "The feature name (echoes input)."
  value       = var.feature_name
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "state" {
  description = "The registration state of the feature (e.g. Registered, Registering, Pending)."
  value       = try(rest_resource.feature_registration.output.properties.state, null)
}
