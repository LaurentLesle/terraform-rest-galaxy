# Unit test — modules/github/runner_group
# Tests the sub-module in isolation (plan only).
# Run: terraform test -filter=tests/unit_github_runner_group.tftest.hcl

provider "rest" {
  base_url = "https://api.github.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_runner_group" {
  command = plan

  module {
    source = "./modules/github/runner_group"
  }

  variables {
    organization               = "my-org"
    name                       = "azure-vnet-runners"
    visibility                 = "all"
    allows_public_repositories = false
    network_configuration_id   = "/subscriptions/${var.subscription_id}/resourceGroups/rg-runners/providers/GitHub.Network/networkSettings/ns-runners"
  }

  assert {
    condition     = output.name == "azure-vnet-runners"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.organization == "my-org"
    error_message = "Organization output must echo input."
  }

  assert {
    condition     = output.visibility == "all"
    error_message = "Visibility output must echo input."
  }

  assert {
    condition     = output.network_configuration_id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-runners/providers/GitHub.Network/networkSettings/ns-runners"
    error_message = "Network configuration ID output must echo input."
  }
}
