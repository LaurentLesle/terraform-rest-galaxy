output "name" {
  description = "The name of the ConfigMap."
  value       = var.name
}

output "namespace" {
  description = "The namespace of the ConfigMap."
  value       = var.namespace
}

output "uid" {
  description = "The UID of the ConfigMap assigned by K8s."
  value       = try(rest_resource.config_map.output.metadata.uid, null)
}
