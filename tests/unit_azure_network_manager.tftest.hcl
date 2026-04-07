# Unit test — modules/azure/network_manager
# Tests the sub-module in isolation (plan only, no ref resolution).
# Run: terraform test -filter=tests/unit_azure_network_manager.tftest.hcl

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = var.access_token
      }
    }
  }
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_network_manager" {
  command = plan

  module {
    source = "./modules/azure/network_manager"
  }

  variables {
    subscription_id      = var.subscription_id
    resource_group_name  = "test-rg"
    network_manager_name = "nm-test"
    location             = "westeurope"
    scope_subscriptions  = ["/subscriptions/${var.subscription_id}"]
    scope_accesses       = ["Connectivity"]
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/test-rg/providers/Microsoft.Network/networkManagers/nm-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "nm-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.resource_group_name == "test-rg"
    error_message = "Resource group name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
