# Unit test — modules/azure/log_analytics_workspace
# Run: terraform test -filter=tests/unit_azure_log_analytics_workspace.tftest.hcl

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

run "plan_log_analytics_workspace" {
  command = plan

  module {
    source = "./modules/azure/log_analytics_workspace"
  }

  variables {
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    resource_group_name = "test-rg"
    workspace_name      = "law-test-workspace"
    location            = "westeurope"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/law-test-workspace"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "law-test-workspace"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
