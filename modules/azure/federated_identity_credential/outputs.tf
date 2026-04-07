output "id" {
  description = "The full ARM resource ID of the federated identity credential."
  value       = local.fic_path
}

output "name" {
  description = "The name of the federated identity credential."
  value       = var.federated_credential_name
}

output "issuer" {
  description = "The OIDC issuer URL."
  value       = var.issuer
}

output "subject" {
  description = "The subject identifier."
  value       = var.subject
}
