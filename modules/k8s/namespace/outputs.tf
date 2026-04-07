output "name" {
  description = "The name of the namespace."
  value       = var.name
}

output "uid" {
  description = "The UID of the namespace assigned by K8s."
  value       = try(rest_resource.namespace.output.metadata.uid, null)
}

output "phase" {
  description = "The phase of the namespace (e.g. Active)."
  value       = try(rest_resource.namespace.output.status.phase, null)
}
