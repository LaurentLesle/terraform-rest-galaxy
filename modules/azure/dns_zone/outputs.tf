output "id" {
  description = "The full ARM resource ID of the DNS zone."
  value       = local.zone_path
}

output "api_version" {
  description = "The ARM API version used to manage this DNS zone."
  value       = "2018-05-01"
}

output "name" {
  description = "The DNS zone name (plan-time, echoes input)."
  value       = var.zone_name
}

output "location" {
  description = "The location (plan-time, echoes input)."
  value       = var.location
}

output "name_servers" {
  description = "The name servers for the DNS zone (after-apply)."
  value       = try(rest_resource.dns_zone.output.properties.nameServers, null)
}

output "number_of_record_sets" {
  description = "The number of record sets in the zone."
  value       = try(rest_resource.dns_zone.output.properties.numberOfRecordSets, null)
}
