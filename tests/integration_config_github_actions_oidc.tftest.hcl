# Integration test — configurations/github_actions_oidc.yaml
# Run: terraform test -filter=tests/integration_config_github_actions_oidc.tftest.hcl

# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.
# Adding one causes "Provider type mismatch" errors with unit tests.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "github_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_github_actions_oidc" {
  command = plan

  variables {
    config_file     = "configurations/github_actions_oidc.yaml"
    subscription_id = var.subscription_id
  }

  # Resource group exists
  assert {
    condition     = output.azure_values.azure_resource_groups["github_oidc"] != null
    error_message = "Plan failed — resource group not found."
  }

  # User-assigned managed identity
  assert {
    condition     = output.azure_values.azure_user_assigned_identities["github_actions"].name == "id-github-actions"
    error_message = "Identity name must match config."
  }

  # Federated identity credential (main branch)
  assert {
    condition     = output.azure_values.azure_federated_identity_credentials["github_main"] != null
    error_message = "GitHub OIDC federated credential (main) must exist."
  }

  # Federated identity credential (pull requests)
  assert {
    condition     = output.azure_values.azure_federated_identity_credentials["github_pr"] != null
    error_message = "GitHub OIDC federated credential (PR) must exist."
  }

  # Role assignment (Contributor on subscription)
  assert {
    condition     = output.azure_values.azure_role_assignments["github_actions_contributor"] != null
    error_message = "Contributor role assignment must exist."
  }

  # GitHub Actions secrets
  assert {
    condition     = output.github_values.github_repository_secrets["azure_client_id"].name == "AZURE_CLIENT_ID"
    error_message = "AZURE_CLIENT_ID secret must be set."
  }

  assert {
    condition     = output.github_values.github_repository_secrets["azure_tenant_id"].name == "AZURE_TENANT_ID"
    error_message = "AZURE_TENANT_ID secret must be set."
  }

  assert {
    condition     = output.github_values.github_repository_secrets["azure_subscription_id"].name == "AZURE_SUBSCRIPTION_ID"
    error_message = "AZURE_SUBSCRIPTION_ID secret must be set."
  }
}
