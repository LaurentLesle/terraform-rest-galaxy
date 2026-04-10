# Plan-only test — configurations/acme_github_runners.yaml
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/config_acme_github_runners.tftest.hcl

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

variable "github_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_acme_github_runners" {
  command = plan

  variables {
    azure_access_token = var.access_token
    graph_access_token = var.graph_access_token
    github_token       = var.github_token
    config_file        = "configurations/acme_github_runners.yaml"
    subscription_id    = var.subscription_id
  }

  # Resource group exists
  assert {
    condition     = output.azure_values.azure_resource_groups["github_runners"] != null
    error_message = "Plan failed — resource group not found."
  }

  # VNet for runners
  assert {
    condition     = output.azure_values.azure_virtual_networks["github_runners"].name == "vnet-acme-github-runners"
    error_message = "Runner VNet name must match config."
  }

  # Virtual hub connection
  assert {
    condition     = output.azure_values.azure_virtual_hub_connections["hub3a_to_github_runners"] != null
    error_message = "Virtual hub connection to runner VNet must exist."
  }

  # DNS resolver
  assert {
    condition     = output.azure_values.azure_dns_resolvers["github_runners"].name == "dnspr-acme-github-runners"
    error_message = "DNS resolver name must match config."
  }

  # Private DNS zones
  assert {
    condition     = output.azure_values.azure_private_dns_zones["privatelink_blob"] != null
    error_message = "Blob private DNS zone must exist."
  }

  # User-assigned identity
  assert {
    condition     = output.azure_values.azure_user_assigned_identities["github_runner"].name == "id-acme-github-runner"
    error_message = "Runner identity name must match config."
  }

  # Federated identity credentials
  assert {
    condition     = output.azure_values.azure_federated_identity_credentials["github_runner_main"] != null
    error_message = "GitHub OIDC federated credential (main) must exist."
  }

  assert {
    condition     = output.azure_values.azure_federated_identity_credentials["github_runner_pr"] != null
    error_message = "GitHub OIDC federated credential (PR) must exist."
  }

  # GitHub.Network/networkSettings
  assert {
    condition     = output.azure_values.azure_github_network_settings["runners"].name == "ns-acme-github-runners"
    error_message = "GitHub network settings name must match config."
  }

  # GitHub runner group
  assert {
    condition     = output.github_values.github_runner_groups["azure_vnet_runners"].name == "azure-vnet-runners"
    error_message = "Runner group name must match config."
  }

  # GitHub hosted runner
  assert {
    condition     = output.github_values.github_hosted_runners["linux_4core"].name == "linux-4core-vnet"
    error_message = "Hosted runner name must match config."
  }
}
