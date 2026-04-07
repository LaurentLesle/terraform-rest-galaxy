output "name" {
  description = "The name of the Deployment."
  value       = var.name
}

output "namespace" {
  description = "The namespace of the Deployment."
  value       = var.namespace
}

output "uid" {
  description = "The UID of the Deployment assigned by K8s."
  value       = try(rest_resource.deployment.output.metadata.uid, null)
}

output "available_replicas" {
  description = "The number of available replicas."
  value       = try(rest_resource.deployment.output.status.availableReplicas, null)
}

output "ready_replicas" {
  description = "The number of ready replicas."
  value       = try(rest_resource.deployment.output.status.readyReplicas, null)
}
