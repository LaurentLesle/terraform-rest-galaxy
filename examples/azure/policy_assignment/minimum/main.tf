terraform {
  required_providers {
    rest = {
      source  = "LaurentLesle/rest"
      version = "~> 1.0"
    }
  }
}

provider "rest" {
  base_url = "https://login.microsoftonline.com"
  alias    = "access_token"
}

resource "rest_operation" "access_token" {
  count  = var.access_token == null ? 1 : 0
  path   = "/${var.tenant_id != null ? var.tenant_id : ""}/oauth2/v2.0/token"
  method = "POST"
  header = {
    Accept       = "application/json"
    Content-Type = "application/x-www-form-urlencoded"
  }
  body = {
    client_assertion      = var.id_token
    client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
    client_id             = var.client_id
    grant_type            = "client_credentials"
    scope                 = "https://management.azure.com/.default"
  }
  provider = rest.access_token
}

locals {
  azure_token = coalesce(
    var.access_token,
    try(rest_operation.access_token[0].output["access_token"], "")
  )
}

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = local.azure_token
      }
    }
  }
}

module "root" {
  source = "../../../../"

  azure_management_groups = {
    mg_root = {
      display_name = "Contoso Root"
    }
  }

  azure_policy_assignments = {
    # Audit-only assignment of CIS benchmark (built-in initiative via externals)
    root_cis_benchmark = {
      scope                = "ref:azure_management_groups.mg_root.id"
      policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/06f19060-9e68-4070-92ca-f15cc126059e"
      display_name         = "CIS Microsoft Azure Foundations Benchmark v2.0.0 (root)"
      enforcement_mode     = "DoNotEnforce"
      non_compliance_messages = [
        { message = "Resource does not comply with CIS Microsoft Azure Foundations Benchmark v2.0.0." }
      ]
    }

    # DINE assignment — requires SystemAssigned managed identity for remediation
    root_configure_ama_linux = {
      scope                = "ref:azure_management_groups.mg_root.id"
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a4034bc6-ae50-406d-bf76-50f4ee5a7811"
      display_name         = "Configure Azure Monitor Agent on Linux VMs (root)"
      enforcement_mode     = "Default"
      identity_type        = "SystemAssigned"
      location             = "westeurope"
    }
  }
}
