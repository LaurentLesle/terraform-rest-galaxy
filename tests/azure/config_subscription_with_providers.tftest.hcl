# Apply test — configurations/subscription_with_providers.yaml
# Tests a config that deploys a subscription with resource provider registrations,
# resource group, identity, key vault, key, role assignment, and CMK storage account.
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/config_subscription_with_providers.tftest.hcl

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

run "plan_subscription_with_providers" {
  command = plan

  variables {
    azure_access_token = var.access_token
    graph_access_token = var.graph_access_token
    config_file        = "configurations/subscription_with_providers.yaml"
    subscription_id    = var.subscription_id
  }

  # Subscription alias
  assert {
    condition     = output.azure_values.azure_subscriptions["dev"] != null
    error_message = "Plan failed — subscription 'dev' not found."
  }

  # Resource provider registrations
  assert {
    condition     = output.azure_values.azure_resource_provider_registrations["compute"] != null
    error_message = "Compute resource provider registration must exist."
  }

  assert {
    condition     = output.azure_values.azure_resource_provider_registrations["storage"] != null
    error_message = "Storage resource provider registration must exist."
  }

  # Resource provider feature
  assert {
    condition     = output.azure_values.azure_resource_provider_features["encryption_at_host"] != null
    error_message = "EncryptionAtHost feature must exist."
  }

  # Resource group
  assert {
    condition     = output.azure_values.azure_resource_groups["dev"] != null
    error_message = "Resource group 'dev' must exist."
  }

  # User-assigned identity
  assert {
    condition     = output.azure_values.azure_user_assigned_identities["cmk_sa"].name == "id-sub-cmk-sa"
    error_message = "CMK identity name must match config."
  }

  # Key vault
  assert {
    condition     = output.azure_values.azure_key_vaults["cmk"].name == "kv-sub-cmk"
    error_message = "Key vault name must match config."
  }

  # Storage account with CMK
  assert {
    condition     = output.azure_values.azure_storage_accounts["dev"].name == "sasub001"
    error_message = "Storage account name must match config."
  }
}
