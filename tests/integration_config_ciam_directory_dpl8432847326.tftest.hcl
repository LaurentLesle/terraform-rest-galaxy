# Plan-only test for configurations/ciam_directory_dpl8432847326.yaml
# Run: terraform test -filter=tests/integration_config_ciam_directory_dpl8432847326.tftest.hcl
#
# Validates the CIAM directory configuration YAML.
# Checks that all ref: expressions resolve (including externals) and the plan succeeds.

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

run "plan_ciam_directory_dpl8432847326" {
  command = plan

  variables {
    config_file     = "configurations/ciam_directory_dpl8432847326.yaml"
    subscription_id = var.subscription_id
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["dpl8432847326"] != null
    error_message = "Plan failed — resource group 'dpl8432847326' not found."
  }

  assert {
    condition     = output.azure_values.azure_ciam_directories["dpl8432847326"] != null
    error_message = "Plan failed — CIAM directory 'dpl8432847326' not found."
  }

  assert {
    condition     = output.azure_values.azure_ciam_directories["dpl8432847326"].location == "Europe"
    error_message = "Plan failed — CIAM directory location should resolve to 'Europe' from externals ref."
  }
}
