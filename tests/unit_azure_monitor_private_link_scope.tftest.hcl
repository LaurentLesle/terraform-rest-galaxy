# Unit test — modules/azure/monitor_private_link_scope
# Run: terraform test -filter=tests/unit_azure_monitor_private_link_scope.tftest.hcl
#
# Tests plan-time-known outputs only (id, name, location).
# API version: 2021-09-01 (stable).

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

run "plan_monitor_private_link_scope" {
  command = plan

  module {
    source = "./modules/azure/monitor_private_link_scope"
  }

  variables {
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    resource_group_name = "test-rg"
    scope_name          = "ampls-test"
    location            = "westeurope"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/privateLinkScopes/ampls-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "ampls-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
