# Unit test — modules/azure/alert_processing_rule
# Run: terraform test -filter=tests/unit_azure_alert_processing_rule.tftest.hcl

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

run "plan_alert_processing_rule" {
  command = plan

  module {
    source = "./modules/azure/alert_processing_rule"
  }

  variables {
    subscription_id            = "00000000-0000-0000-0000-000000000000"
    resource_group_name        = "test-rg"
    alert_processing_rule_name = "apr-test"
    location                   = "westeurope"
    enabled                    = true
    scopes                     = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    actions = [
      {
        action_type = "RemoveAllActionGroups"
      }
    ]
    description = "Test alert processing rule"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.AlertsManagement/actionRules/apr-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "apr-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.enabled == true
    error_message = "Enabled output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
