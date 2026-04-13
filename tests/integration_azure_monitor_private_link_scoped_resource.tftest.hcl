# Integration test — monitor_private_link_scoped_resource (plan only)
# Run: terraform test -filter=tests/integration_azure_monitor_private_link_scoped_resource.tftest.hcl
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_monitor_private_link_scoped_resource" {
  command = plan

  variables {
    azure_monitor_private_link_scoped_resources = {
      test = {
        subscription_id         = var.subscription_id
        resource_group_name     = "rg-test"
        private_link_scope_name = "ampls-test"
        scoped_resource_name    = "link-law"
        linked_resource_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/law-test"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scoped_resources["test"].id != null
    error_message = "Plan failed — scoped resource 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scoped_resources["test"].name == "link-law"
    error_message = "Plan failed — scoped resource name must be 'link-law'."
  }
}
