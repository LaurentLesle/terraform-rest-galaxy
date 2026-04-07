# Unit test — modules/azure/ipam_pool
# Tests the sub-module in isolation (plan only, no ref resolution).
# Run: terraform test -filter=tests/unit_azure_ipam_pool.tftest.hcl

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

run "plan_ipam_pool" {
  command = plan

  module {
    source = "./modules/azure/ipam_pool"
  }

  variables {
    subscription_id      = var.subscription_id
    resource_group_name  = "test-rg"
    network_manager_name = "nm-test"
    pool_name            = "pool-test"
    location             = "westeurope"
    address_prefixes     = ["10.0.0.0/8"]
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/test-rg/providers/Microsoft.Network/networkManagers/nm-test/ipamPools/pool-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "pool-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.network_manager_name == "nm-test"
    error_message = "Network manager name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
