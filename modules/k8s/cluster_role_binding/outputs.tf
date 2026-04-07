output "name" {
  description = "The name of the ClusterRoleBinding."
  value       = var.name
}

output "uid" {
  description = "The UID of the ClusterRoleBinding assigned by K8s."
  value       = try(rest_resource.cluster_role_binding.output.metadata.uid, null)
}
