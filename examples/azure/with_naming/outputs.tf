output "azure_resource_groups" {
  description = "Map of resource group outputs from the root module."
  value       = module.root.azure_values.azure_resource_groups
}

output "azure_storage_accounts" {
  description = "Map of storage account outputs from the root module."
  value       = module.root.azure_values.azure_storage_accounts
}

output "azure_key_vaults" {
  description = "Map of key vault outputs from the root module."
  value       = module.root.azure_values.azure_key_vaults
}

output "naming" {
  description = "Generated names from the naming module."
  value = {
    resource_group  = module.naming.resource_group.name
    storage_account = module.naming.storage_account.name_unique
    key_vault       = module.naming.key_vault.name_unique
  }
}
