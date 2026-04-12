# Integration test — configurations/observability_private.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_observability_private.tftest.hcl
#
# Validates the full private observability AMPLS configuration without deploying to Azure.
# Checks ref: resolution, variable types, and dependency graph for all Phase 2 resources.
#
# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.
# Adding one causes "Provider type mismatch" errors with unit tests.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

run "plan_observability_private" {
  command = plan

  variables {
    config_file     = "configurations/observability_private.yaml"
    subscription_id = var.subscription_id
    tenant_id       = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["obs-private"] != null
    error_message = "Plan failed — resource group 'obs-private' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_workspaces["obs-private"] != null
    error_message = "Plan failed — monitor workspace 'obs-private' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scopes["obs-private"] != null
    error_message = "Plan failed — AMPLS 'obs-private' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scoped_resources["ampls-amw"] != null
    error_message = "Plan failed — AMPLS scoped resource 'ampls-amw' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_monitor_private_link_scoped_resources["ampls-dce"] != null
    error_message = "Plan failed — AMPLS scoped resource 'ampls-dce' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_private_dns_zones["monitor"] != null
    error_message = "Plan failed — private DNS zone 'monitor' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_private_dns_zone_virtual_network_links["monitor-link"] != null
    error_message = "Plan failed — VNet link 'monitor-link' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_private_endpoints["ampls"] != null
    error_message = "Plan failed — private endpoint 'ampls' not found in output."
  }
}
