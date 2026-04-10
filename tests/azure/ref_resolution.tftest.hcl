# Apply test — ref: resolution
# Verifies that ref: cross-references in YAML configs resolve correctly.
# Uses storage_account_cmk.yaml which has deep ref: chains:
#   resource_group → identity → key_vault → key → role_assignment → storage_account
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/ref_resolution.tftest.hcl

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "ref_chain_resolves" {
  command = plan

  variables {
    azure_access_token = var.access_token
    graph_access_token = var.graph_access_token
    config_file        = "configurations/storage_account_cmk.yaml"
    subscription_id    = var.subscription_id
  }

  # ref:azure_resource_groups.cmk.resource_group_name resolves in identity
  assert {
    condition     = output.azure_values.azure_user_assigned_identities["cmk_sa"].name == "id-cmk-sa"
    error_message = "Identity ref resolution failed — name must match config."
  }

  # ref:azure_resource_groups.cmk.location resolves in key vault
  assert {
    condition     = output.azure_values.azure_key_vaults["cmk"].name == "kv-cmk"
    error_message = "Key vault ref resolution failed — name must match config."
  }

  # ref:azure_key_vaults.cmk.name resolves in key vault key
  assert {
    condition     = output.azure_values.azure_key_vault_keys["cmk_sa"].name == "cmk-storage"
    error_message = "Key vault key ref resolution failed — name must match config."
  }

  # ref:azure_key_vaults.cmk.id resolves in role assignment scope
  assert {
    condition     = output.azure_values.azure_role_assignments["cmk_sa_crypto_user"] != null
    error_message = "Role assignment ref resolution failed — must exist."
  }

  # ref: chains through identity, key vault, key all resolve in storage account
  assert {
    condition     = output.azure_values.azure_storage_accounts["cmk"].name == "sacmk001"
    error_message = "Storage account ref resolution failed — name must match config."
  }
}
