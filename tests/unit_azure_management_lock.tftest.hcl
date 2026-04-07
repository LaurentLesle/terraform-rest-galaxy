# Unit test — modules/azure/management_lock
# Tests the sub-module in isolation (plan only).
# Run: terraform test -filter=tests/unit_azure_management_lock.tftest.hcl

provider "rest" {
  base_url = "https://management.azure.com"
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

run "plan_management_lock" {
  command = plan

  module {
    source = "./modules/azure/management_lock"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-terraform-state"
    lock_name           = "protect-terraform-state"
    lock_level          = "CanNotDelete"
    notes               = "Protects state storage from accidental deletion."
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-terraform-state/providers/Microsoft.Authorization/locks/protect-terraform-state"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.lock_name == "protect-terraform-state"
    error_message = "lock_name output must echo input."
  }

  assert {
    condition     = output.lock_level == "CanNotDelete"
    error_message = "lock_level output must echo input."
  }
}
