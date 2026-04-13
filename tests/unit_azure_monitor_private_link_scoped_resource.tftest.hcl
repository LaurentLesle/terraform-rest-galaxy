# Unit test — modules/azure/monitor_private_link_scoped_resource
# Run: terraform test -filter=tests/unit_azure_monitor_private_link_scoped_resource.tftest.hcl
#
# Tests plan-time-known outputs only (id, name).
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

run "plan_monitor_private_link_scoped_resource" {
  command = plan

  module {
    source = "./modules/azure/monitor_private_link_scoped_resource"
  }

  variables {
    subscription_id         = "00000000-0000-0000-0000-000000000000"
    resource_group_name     = "test-rg"
    private_link_scope_name = "ampls-test"
    scoped_resource_name    = "link-law"
    linked_resource_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/law-test"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/privateLinkScopes/ampls-test/scopedResources/link-law"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "link-law"
    error_message = "Name output must echo input."
  }
}
