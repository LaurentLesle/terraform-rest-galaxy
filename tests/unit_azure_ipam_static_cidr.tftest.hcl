# Unit test — modules/azure/ipam_static_cidr
# Tests the sub-module in isolation (plan only, no ref resolution).
# Run: terraform test -filter=tests/unit_azure_ipam_static_cidr.tftest.hcl

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

run "plan_ipam_static_cidr" {
  command = plan

  module {
    source = "./modules/azure/ipam_static_cidr"
  }

  variables {
    subscription_id      = var.subscription_id
    resource_group_name  = "test-rg"
    network_manager_name = "nm-test"
    pool_name            = "pool-test"
    static_cidr_name     = "hub1"
    address_prefixes     = ["10.1.0.0/24"]
    description          = "Hub 1 reservation"
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/test-rg/providers/Microsoft.Network/networkManagers/nm-test/ipamPools/pool-test/staticCidrs/hub1"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "hub1"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.pool_name == "pool-test"
    error_message = "Pool name output must echo input."
  }

  assert {
    condition     = output.network_manager_name == "nm-test"
    error_message = "Network manager name output must echo input."
  }
}
