# Plan-only test — configurations/vwan_secure_hub_routing_intent.yaml
# Run: terraform test -test-directory=tests/azure -filter=tests/azure/config_vwan_secure_hub_routing_intent.tftest.hcl

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

run "plan_vwan_secure_hub_routing_intent" {
  command = plan

  variables {
    azure_access_token = var.access_token
    graph_access_token = var.graph_access_token
    config_file        = "configurations/vwan_secure_hub_routing_intent.yaml"
    subscription_id    = var.subscription_id
  }

  # Resource group
  assert {
    condition     = output.azure_values.azure_resource_groups["hub"] != null
    error_message = "Plan failed — resource group 'hub' not found."
  }

  # Virtual WAN
  assert {
    condition     = output.azure_values.azure_virtual_wans["hub"].name == "vwan-hub"
    error_message = "Virtual WAN name must match config."
  }

  # Firewall policy
  assert {
    condition     = output.azure_values.azure_firewall_policies["hub"].name == "afwp-hub"
    error_message = "Firewall policy name must match config."
  }

  # Virtual hub
  assert {
    condition     = output.azure_values.azure_virtual_hubs["hub"].name == "vhub-hub"
    error_message = "Virtual hub name must match config."
  }

  # Azure Firewall
  assert {
    condition     = output.azure_values.azure_firewalls["hub"].name == "afw-hub"
    error_message = "Firewall name must match config."
  }

  # Routing intent
  assert {
    condition     = output.azure_values.azure_routing_intents["hub"] != null
    error_message = "Routing intent must exist."
  }
}
