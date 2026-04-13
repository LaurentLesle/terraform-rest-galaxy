# Unit test — modules/azure/monitor_workspace
# Run: terraform test -filter=tests/unit_azure_monitor_workspace.tftest.hcl
#
# NOTE: API version is 2023-10-01-preview (no stable version available).
# Tests plan-time-known outputs only (id, name, location).

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

run "plan_monitor_workspace" {
  command = plan

  module {
    source = "./modules/azure/monitor_workspace"
  }

  variables {
    subscription_id        = "00000000-0000-0000-0000-000000000000"
    resource_group_name    = "test-rg"
    monitor_workspace_name = "amw-test-workspace"
    location               = "westeurope"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Monitor/accounts/amw-test-workspace"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "amw-test-workspace"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
