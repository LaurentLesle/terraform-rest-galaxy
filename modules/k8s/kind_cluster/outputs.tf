output "name" {
  description = "The name of the kind cluster."
  value       = kind_cluster.this.name
}

output "endpoint" {
  description = "The API server endpoint of the kind cluster."
  value       = kind_cluster.this.endpoint
}

output "kubeconfig" {
  description = "The kubeconfig for the kind cluster."
  value       = kind_cluster.this.kubeconfig
  sensitive   = true
}

output "client_certificate" {
  description = "Client certificate for authenticating to the cluster."
  value       = kind_cluster.this.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client key for authenticating to the cluster."
  value       = kind_cluster.this.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate."
  value       = kind_cluster.this.cluster_ca_certificate
  sensitive   = true
}

output "kubernetes_version" {
  description = "The Kubernetes version of the cluster (echoes input)."
  value       = var.kubernetes_version
}
