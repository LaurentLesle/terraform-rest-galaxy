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

  azure_policy_definitions = {
    deny_unapproved_regions = {
      scope        = "ref:azure_management_groups.mg_root.id"
      display_name = "Deny resources outside approved regions"
      mode         = "Indexed"
      metadata = {
        category = "Location"
        version  = "1.0.0"
      }
      parameters = {
        allowedLocations = {
          type = "Array"
          metadata = {
            displayName = "Allowed locations"
            description = "List of Azure regions where resources are permitted."
          }
          defaultValue = ["westeurope", "northeurope"]
        }
      }
      policy_rule = {
        if = {
          not = {
            field = "location"
            in    = "[parameters('allowedLocations')]"
          }
        }
        then = { effect = "Deny" }
      }
    }
  }
}
