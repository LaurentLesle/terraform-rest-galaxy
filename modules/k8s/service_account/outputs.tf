output "name" {
  description = "The name of the ServiceAccount."
  value       = var.name
}

output "namespace" {
  description = "The namespace of the ServiceAccount."
  value       = var.namespace
}

output "uid" {
  description = "The UID of the ServiceAccount assigned by K8s."
  value       = try(rest_resource.service_account.output.metadata.uid, null)
}
