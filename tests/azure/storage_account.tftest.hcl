# Apply test — modules/azure/storage_account
# Creates a resource group and storage account, verifies outputs, and destroys both.
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/storage_account.tftest.hcl

# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

variable "access_token" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

run "apply_storage_account" {
  command = apply

  variables {
    azure_access_token = var.access_token
    subscription_id    = var.subscription_id
    azure_resource_groups = {
      sa_ci = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-tftest-sa-ci"
        location            = "westeurope"
        tags = {
          environment = "ci-test"
          managed_by  = "terraform-test"
        }
      }
    }
    azure_storage_accounts = {
      ci_test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-tftest-sa-ci"
        account_name        = "tftestsaci001"
        sku_name            = "Standard_LRS"
        kind                = "StorageV2"
        location            = "westeurope"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["sa_ci"].provisioning_state == "Succeeded"
    error_message = "Resource group must be in Succeeded state."
  }

  assert {
    condition     = output.azure_values.azure_storage_accounts["ci_test"].name == "tftestsaci001"
    error_message = "Storage account name must echo input."
  }

  assert {
    condition     = output.azure_values.azure_storage_accounts["ci_test"].location == "westeurope"
    error_message = "location output must echo input."
  }

  assert {
    condition     = output.azure_values.azure_storage_accounts["ci_test"].kind == "StorageV2"
    error_message = "kind output must echo input."
  }

  assert {
    condition     = output.azure_values.azure_storage_accounts["ci_test"].sku_name == "Standard_LRS"
    error_message = "sku_name output must echo input."
  }

  assert {
    condition     = output.azure_values.azure_storage_accounts["ci_test"].provisioning_state == "Succeeded"
    error_message = "Storage account must be in Succeeded state after apply."
  }
}
