# Config-level plan test — configurations/governance_landing_zone.yaml
#
# Validates the full governance stack at plan time:
#   - Management group hierarchy ARM paths are correctly formed
#   - Policy definitions, initiatives, and assignments are present
#   - ref: cross-references resolve (MG IDs used as policy scopes)
#   - Resource counts match the ALZ reference architecture
#
# IMPORTANT: Do NOT add provider blocks here.
# The root module's provider config flows through automatically.
#
# Run:
#   cd .build && terraform test -test-directory=tests/azure -filter=tests/azure/config_governance_landing_zone.tftest.hcl

variable "azure_access_token" {
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

run "plan_governance_config" {
  command = plan

  variables {
    azure_access_token = var.azure_access_token
    graph_access_token = var.graph_access_token
    config_file        = "configurations/governance_landing_zone.yaml"
    subscription_id    = var.subscription_id
  }

  # ── Management group ARM paths ────────────────────────────────────────────

  assert {
    condition     = output.azure_values.azure_management_groups["mg_root"].id == "/providers/Microsoft.Management/managementGroups/mg_root"
    error_message = "mg_root ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_management_groups["mg_platform"].id == "/providers/Microsoft.Management/managementGroups/mg_platform"
    error_message = "mg_platform ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_management_groups["mg_landing_zones"].id == "/providers/Microsoft.Management/managementGroups/mg_landing_zones"
    error_message = "mg_landing_zones ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_management_groups["mg_corp"].id == "/providers/Microsoft.Management/managementGroups/mg_corp"
    error_message = "mg_corp ARM path must be correctly formed."
  }

  # ── Policy definition ARM paths ───────────────────────────────────────────

  assert {
    condition     = output.azure_values.azure_policy_definitions["deny_unapproved_regions"].id == "/providers/Microsoft.Management/managementGroups/mg_root/providers/Microsoft.Authorization/policyDefinitions/deny_unapproved_regions"
    error_message = "deny_unapproved_regions policy definition ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_policy_definitions["deny_public_subnets"].id == "/providers/Microsoft.Management/managementGroups/mg_landing_zones/providers/Microsoft.Authorization/policyDefinitions/deny_public_subnets"
    error_message = "deny_public_subnets policy definition scoped to mg_landing_zones."
  }

  # ── Initiative (policy set definition) ARM paths ──────────────────────────

  assert {
    condition     = output.azure_values.azure_policy_set_definitions["lz_tagging_baseline"].id == "/providers/Microsoft.Management/managementGroups/mg_root/providers/Microsoft.Authorization/policySetDefinitions/lz_tagging_baseline"
    error_message = "lz_tagging_baseline initiative ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_policy_set_definitions["lz_network_baseline"].id == "/providers/Microsoft.Management/managementGroups/mg_landing_zones/providers/Microsoft.Authorization/policySetDefinitions/lz_network_baseline"
    error_message = "lz_network_baseline initiative scoped to mg_landing_zones."
  }

  # ── Policy assignment ARM paths ───────────────────────────────────────────

  assert {
    condition     = output.azure_values.azure_policy_assignments["root_mdc_configure_plans"].id == "/providers/Microsoft.Management/managementGroups/mg_root/providers/Microsoft.Authorization/policyAssignments/root_mdc_configure_plans"
    error_message = "root_mdc_configure_plans assignment ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_policy_assignments["lz_soc2"].id == "/providers/Microsoft.Management/managementGroups/mg_landing_zones/providers/Microsoft.Authorization/policyAssignments/lz_soc2"
    error_message = "lz_soc2 assignment scoped to mg_landing_zones."
  }

  assert {
    condition     = output.azure_values.azure_policy_assignments["root_k8s_no_privileged_containers"].id == "/providers/Microsoft.Management/managementGroups/mg_root/providers/Microsoft.Authorization/policyAssignments/root_k8s_no_privileged_containers"
    error_message = "root_k8s_no_privileged_containers assignment ARM path must be correctly formed."
  }

  assert {
    condition     = output.azure_values.azure_policy_assignments["root_configure_linux_arc_ama"].id == "/providers/Microsoft.Management/managementGroups/mg_root/providers/Microsoft.Authorization/policyAssignments/root_configure_linux_arc_ama"
    error_message = "root_configure_linux_arc_ama assignment ARM path must be correctly formed."
  }

  # ── Resource count sanity checks ──────────────────────────────────────────

  assert {
    condition     = length(output.azure_values.azure_management_groups) == 10
    error_message = "Expected 10 management groups (ALZ reference hierarchy)."
  }

  assert {
    condition     = length(output.azure_values.azure_policy_definitions) == 4
    error_message = "Expected 4 custom policy definitions."
  }

  assert {
    condition     = length(output.azure_values.azure_policy_set_definitions) == 2
    error_message = "Expected 2 custom initiatives."
  }
}
