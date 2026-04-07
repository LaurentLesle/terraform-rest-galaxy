# Integration test — configurations/communication_service_email.yaml
# Run: terraform test -filter=tests/integration_config_communication_service_email.tftest.hcl

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

run "plan_communication_service_email" {
  command = plan

  variables {
    config_file     = "configurations/communication_service_email.yaml"
    subscription_id = var.subscription_id
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["acs_email"] != null
    error_message = "Plan failed — resource group 'acs_email' not found."
  }

  assert {
    condition     = output.azure_values.azure_email_communication_services["email"] != null
    error_message = "Plan failed — email communication service 'email' not found."
  }

  assert {
    condition     = output.azure_values.azure_email_communication_service_domains["custom"] != null
    error_message = "Plan failed — email domain 'custom' not found."
  }

  assert {
    condition     = output.azure_values.azure_app_service_domains["dpl_acsemail"] != null
    error_message = "Plan failed — app service domain 'dpl_acsemail' not found."
  }

  assert {
    condition     = output.azure_values.azure_dns_zones["dpl_acsemail"] != null
    error_message = "Plan failed — DNS zone 'dpl_acsemail' not found."
  }

  assert {
    condition     = output.azure_values.azure_dns_record_sets["spf"] != null
    error_message = "Plan failed — DNS record set 'spf' not found."
  }

  assert {
    condition     = output.azure_values.azure_dns_record_sets["dkim"] != null
    error_message = "Plan failed — DNS record set 'dkim' not found."
  }

  assert {
    condition     = output.azure_values.azure_dns_record_sets["dkim2"] != null
    error_message = "Plan failed — DNS record set 'dkim2' not found."
  }

  assert {
    condition     = output.azure_values.azure_communication_services["main"] != null
    error_message = "Plan failed — communication service 'main' not found."
  }
}
