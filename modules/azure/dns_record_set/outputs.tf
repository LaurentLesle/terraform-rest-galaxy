output "id" {
  description = "The full ARM resource ID of the DNS record set."
  value       = local.record_set_path
}

output "api_version" {
  description = "The ARM API version used to manage this record set."
  value       = "2018-05-01"
}

output "record_name" {
  description = "The record set name (plan-time, echoes input)."
  value       = var.record_name
}

output "record_type" {
  description = "The record type (plan-time, echoes input)."
  value       = var.record_type
}

output "fqdn" {
  description = "The fully qualified domain name of the record set."
  value       = try(rest_resource.dns_record_set.output.properties.fqdn, null)
}
