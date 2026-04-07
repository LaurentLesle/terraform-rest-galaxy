output "name" {
  description = "The Helm release name."
  value       = var.name
}

output "namespace" {
  description = "The namespace of the release."
  value       = var.namespace
}

output "status" {
  description = "Release status (deployed, failed, etc.)."
  value       = rest_helm_release.this.status
}

output "chart_version" {
  description = "Version of the deployed chart."
  value       = rest_helm_release.this.chart_version
}

output "app_version" {
  description = "App version of the deployed chart."
  value       = rest_helm_release.this.app_version
}
