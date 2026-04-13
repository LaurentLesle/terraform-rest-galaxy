# Unit test — modules/azure/activity_log_alert
# Run: terraform test -filter=tests/unit_azure_activity_log_alert.tftest.hcl

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

run "plan_activity_log_alert" {
  command = plan

  module {
    source = "./modules/azure/activity_log_alert"
  }

  variables {
    subscription_id         = "00000000-0000-0000-0000-000000000000"
    resource_group_name     = "test-rg"
    activity_log_alert_name = "ala-test"
    location                = "global"
    enabled                 = true
    scopes                  = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    condition = {
      all_of = [
        {
          field  = "category"
          equals = "Administrative"
        },
        {
          field  = "operationName"
          equals = "Microsoft.Resources/deployments/delete"
        }
      ]
    }
    actions = {
      action_groups = [
        {
          action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/actionGroups/ag-test"
        }
      ]
    }
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/activityLogAlerts/ala-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "ala-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.enabled == true
    error_message = "Enabled output must echo input."
  }
}
