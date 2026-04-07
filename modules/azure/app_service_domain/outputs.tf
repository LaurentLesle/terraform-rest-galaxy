output "id" {
  description = "The full ARM resource ID of the App Service Domain."
  value       = local.domain_path
}

output "api_version" {
  description = "The ARM API version used to manage this domain."
  value       = "2024-11-01"
}

output "name" {
  description = "The domain name (plan-time, echoes input)."
  value       = var.domain_name
}

output "location" {
  description = "The location (plan-time, echoes input)."
  value       = var.location
}

output "provisioning_state" {
  description = "The provisioning state of the domain."
  value       = try(rest_resource.app_service_domain.output.properties.provisioningState, null)
}

output "registration_status" {
  description = "The domain registration status (e.g. Active, Pending)."
  value       = try(rest_resource.app_service_domain.output.properties.registrationStatus, null)
}

output "name_servers" {
  description = "The name servers for the domain."
  value       = try(rest_resource.app_service_domain.output.properties.nameServers, null)
}

output "expiration_time" {
  description = "The domain expiration timestamp."
  value       = try(rest_resource.app_service_domain.output.properties.expirationTime, null)
}

output "dns_zone_id" {
  description = "The Azure DNS zone resource ID associated with this domain."
  value       = try(rest_resource.app_service_domain.output.properties.dnsZoneId, null)
}
