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
    require_environment_tag = {
      scope        = "ref:azure_management_groups.mg_root.id"
      display_name = "Require 'environment' tag on all resources"
      mode         = "Indexed"
      policy_rule = {
        if   = { field = "tags['environment']", exists = "false" }
        then = { effect = "Deny" }
      }
    }
    require_owner_tag = {
      scope        = "ref:azure_management_groups.mg_root.id"
      display_name = "Require 'owner' tag on all resources"
      mode         = "Indexed"
      policy_rule = {
        if   = { field = "tags['owner']", exists = "false" }
        then = { effect = "Deny" }
      }
    }
  }

  azure_policy_set_definitions = {
    lz_tagging_baseline = {
      scope        = "ref:azure_management_groups.mg_root.id"
      display_name = "Landing Zone Tagging Baseline"
      description  = "Enforces mandatory tagging standards across all landing zone resources."
      metadata = {
        category = "Tags"
        version  = "1.0.0"
      }
      policy_definition_groups = [
        {
          name         = "mandatory-tags"
          display_name = "Mandatory Tags"
        }
      ]
      policy_definitions = [
        {
          policy_definition_id           = "ref:azure_policy_definitions.require_environment_tag.id"
          policy_definition_reference_id = "require_environment_tag"
          group_names                    = ["mandatory-tags"]
        },
        {
          policy_definition_id           = "ref:azure_policy_definitions.require_owner_tag.id"
          policy_definition_reference_id = "require_owner_tag"
          group_names                    = ["mandatory-tags"]
        }
      ]
    }
  }
}
