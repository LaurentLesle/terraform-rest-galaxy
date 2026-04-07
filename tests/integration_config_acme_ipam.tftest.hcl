# Integration test — configurations/acme_ipam.yaml
# Run: terraform test -filter=tests/integration_config_acme_ipam.tftest.hcl

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

run "plan_acme_ipam" {
  command = plan

  variables {
    config_file     = "configurations/acme_ipam.yaml"
    subscription_id = var.subscription_id
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["networking-uswest"] != null
    error_message = "Plan failed — resource group not found."
  }

  assert {
    condition     = output.azure_values.azure_network_managers["acme"].name == "nm-acme"
    error_message = "Network manager name must match config."
  }

  assert {
    condition     = output.azure_values.azure_ipam_pools["root"].name == "pool-acme-root"
    error_message = "Root IPAM pool name must match config."
  }

  assert {
    condition     = output.azure_values.azure_ipam_pools["hubs"].name == "pool-acme-hubs"
    error_message = "Hubs IPAM pool name must match config."
  }

  assert {
    condition     = output.azure_values.azure_ipam_static_cidrs["hub1-uswest"].name == "hub1-uswest"
    error_message = "Hub1 static CIDR name must match config."
  }

  assert {
    condition     = output.azure_values.azure_ipam_static_cidrs["vnet-ergw-israelcentral"].name == "vnet-ergw-israelcentral"
    error_message = "VNet ERGW static CIDR name must match config."
  }
}
