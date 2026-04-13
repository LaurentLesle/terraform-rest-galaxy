output "id" {
  description = "The full ARM resource ID of the Managed Grafana instance (plan-time, built from inputs)."
  value       = local.grafana_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the Managed Grafana instance (plan-time, echoes input)."
  value       = var.grafana_name
}

output "location" {
  description = "The location of the Managed Grafana instance (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags of the Managed Grafana instance (plan-time, echoes input)."
  value       = var.tags
}

output "provisioning_state" {
  description = "The provisioning state of the Managed Grafana instance."
  value       = try(rest_resource.managed_grafana.output.properties.provisioningState, null)
}

output "endpoint" {
  description = "The endpoint URL of the Grafana instance (known after apply)."
  value       = try(rest_resource.managed_grafana.output.properties.endpoint, null)
}

output "grafana_version" {
  description = "The Grafana software version (known after apply)."
  value       = try(rest_resource.managed_grafana.output.properties.grafanaVersion, null)
}
