# Plan-only test — configurations/storage_account_cmk.yaml
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/config_storage_account_cmk.tftest.hcl

# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

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

run "plan_storage_account_cmk" {
  command = plan

  variables {
    azure_access_token  = var.access_token
    graph_access_token  = var.graph_access_token
    config_file         = "configurations/storage_account_cmk.yaml"
    subscription_id     = var.subscription_id
  }

  # Resource group
  assert {
    condition     = output.azure_values.azure_resource_groups["cmk"] != null
    error_message = "Plan failed — resource group 'cmk' not found."
  }

  # User-assigned identity for CMK
  assert {
    condition     = output.azure_values.azure_user_assigned_identities["cmk_sa"].name == "id-cmk-sa"
    error_message = "CMK identity name must match config."
  }

  # Key vault
  assert {
    condition     = output.azure_values.azure_key_vaults["cmk"].name == "kv-cmk"
    error_message = "Key vault name must match config."
  }

  # Key vault key
  assert {
    condition     = output.azure_values.azure_key_vault_keys["cmk_sa"].name == "cmk-storage"
    error_message = "Key vault key name must match config."
  }

  # Role assignment for crypto user
  assert {
    condition     = output.azure_values.azure_role_assignments["cmk_sa_crypto_user"] != null
    error_message = "Crypto user role assignment must exist."
  }

  # Storage account with CMK
  assert {
    condition     = output.azure_values.azure_storage_accounts["cmk"].name == "sacmk001"
    error_message = "Storage account name must match config."
  }
}
