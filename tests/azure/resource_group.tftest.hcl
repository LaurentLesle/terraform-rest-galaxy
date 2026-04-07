# Apply test — modules/azure/resource_group
# Creates and destroys a real resource group using live Azure credentials.
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/resource_group.tftest.hcl

# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

variable "access_token" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

run "apply_resource_group" {
  command = apply

  variables {
    azure_access_token = var.access_token
    subscription_id    = var.subscription_id
    azure_resource_groups = {
      ci_test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-tftest-ci"
        location            = "westeurope"
        tags = {
          environment = "ci-test"
          managed_by  = "terraform-test"
        }
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["ci_test"].id == "/subscriptions/${var.subscription_id}/resourcegroups/rg-tftest-ci"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["ci_test"].name == "rg-tftest-ci"
    error_message = "name output must echo input."
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["ci_test"].location == "westeurope"
    error_message = "location output must echo input."
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["ci_test"].provisioning_state == "Succeeded"
    error_message = "Resource group must be in Succeeded state after apply."
  }
}
