# Unit test — modules/azure/diagnostic_setting
# Run: terraform test -filter=tests/unit_azure_diagnostic_setting.tftest.hcl
#
# Validates the diagnostic setting module in isolation (plan only).
# Note: diagnostic settings use a scope-based path (no subscription_id in path).
# The resource_id is the full ARM ID of the target resource.

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

run "plan_diagnostic_setting" {
  command = plan

  module {
    source = "./modules/azure/diagnostic_setting"
  }

  variables {
    subscription_id            = "00000000-0000-0000-0000-000000000000"
    resource_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"
    diagnostic_setting_name    = "diag-test"
    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/central-law"
    logs = [
      {
        category_group = "allLogs"
        enabled        = true
      }
    ]
    metrics = [
      {
        category = "AllMetrics"
        enabled  = true
      }
    ]
  }

  assert {
    condition     = output.name == "diag-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.id != null && output.id != ""
    error_message = "ID output must be non-empty."
  }
}
