output "name" {
  description = "The name of the Job."
  value       = var.name
}

output "namespace" {
  description = "The namespace of the Job."
  value       = var.namespace
}

output "uid" {
  description = "The UID of the Job assigned by K8s."
  value       = try(rest_resource.job.output.metadata.uid, null)
}

output "succeeded" {
  description = "Number of pods that reached the Succeeded phase."
  value       = try(rest_resource.job.output.status.succeeded, null)
}

output "failed" {
  description = "Number of pods that reached the Failed phase."
  value       = try(rest_resource.job.output.status.failed, null)
}

output "completion_time" {
  description = "Time the Job completed."
  value       = try(rest_resource.job.output.status.completionTime, null)
}
