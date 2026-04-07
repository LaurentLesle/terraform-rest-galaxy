output "id" {
  description = "The full ARM resource ID of the Email Communication Service domain."
  value       = local.domain_path
}

output "api_version" {
  description = "The ARM API version used to manage this domain."
  value       = "2026-03-18"
}

output "name" {
  description = "The domain name (plan-time, echoes input)."
  value       = var.domain_name
}

output "email_service_name" {
  description = "The parent Email Communication Service name (plan-time, echoes input)."
  value       = var.email_service_name
}

output "location" {
  description = "The location of the domain (plan-time, echoes input)."
  value       = var.location
}

output "domain_management" {
  description = "The domain management type (plan-time, echoes input)."
  value       = var.domain_management
}

output "provisioning_state" {
  description = "The provisioning state of the domain."
  value       = try(rest_resource.email_communication_service_domain.output.properties.provisioningState, null)
}

output "from_sender_domain" {
  description = "P2 sender domain displayed to email recipients."
  value       = try(rest_resource.email_communication_service_domain.output.properties.fromSenderDomain, null)
}

output "mail_from_sender_domain" {
  description = "P1 sender domain present on the email envelope."
  value       = try(rest_resource.email_communication_service_domain.output.properties.mailFromSenderDomain, null)
}

output "verification_records" {
  description = "The DNS verification records required for domain verification (SPF, DKIM, DKIM2, DMARC). After-apply only."
  value       = try(rest_resource.email_communication_service_domain.output.properties.verificationRecords, null)
}
