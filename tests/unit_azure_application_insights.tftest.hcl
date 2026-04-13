# Unit test — modules/azure/application_insights
# Run: terraform test -filter=tests/unit_azure_application_insights.tftest.hcl

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

run "plan_application_insights" {
  command = plan

  module {
    source = "./modules/azure/application_insights"
  }

  variables {
    subscription_id           = "00000000-0000-0000-0000-000000000000"
    resource_group_name       = "test-rg"
    application_insights_name = "appi-test"
    location                  = "westeurope"
    kind                      = "web"
    application_type          = "web"
    workspace_resource_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/components/appi-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "appi-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
