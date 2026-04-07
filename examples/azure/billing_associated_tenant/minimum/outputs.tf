output "billing_associated_tenants" {
  description = "The billing associated tenant outputs."
  value       = module.root.azure_values.azure_billing_associated_tenants
}
