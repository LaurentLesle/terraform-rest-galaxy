terraform {
  required_providers {
    rest = {
      source  = "LaurentLesle/rest"
      version = "~> 1.0"
    }
  }
}

# ── Token exchange for OIDC (GitHub Actions CI) ──────────────────────────────

provider "rest" {
  base_url = "https://login.microsoftonline.com"
  alias    = "access_token"
}

resource "rest_operation" "graph_token" {
  count  = var.graph_access_token == null ? 1 : 0
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
    scope                 = "https://graph.microsoft.com/.default"
  }
  provider = rest.access_token
}

locals {
  graph_token = coalesce(
    var.graph_access_token,
    try(rest_operation.graph_token[0].output["access_token"], "")
  )
}

# ── ARM provider (required by root module even if unused) ────────────────────

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = var.access_token
      }
    }
  }
}

# ── Graph provider for Entra ID resources ────────────────────────────────────

provider "rest" {
  alias    = "graph"
  base_url = "https://graph.microsoft.com"
  security = {
    http = {
      token = {
        token = local.graph_token
      }
    }
  }
}

# Call the root module with a fully-configured application.
module "root" {
  source = "../../../../"

  graph_access_token = local.graph_token

  entraid_applications = {
    complete = {
      display_name     = var.display_name
      sign_in_audience = "AzureADMyOrg"
      description      = "Complete example application with web redirects, API permissions, and app roles."
      notes            = "Managed by Terraform"
      tags             = ["terraform", "example"]

      web = {
        redirect_uris                = var.web_redirect_uris
        home_page_url                = var.home_page_url
        logout_url                   = var.logout_url
        implicit_grant_access_tokens = false
        implicit_grant_id_tokens     = true
      }

      # Request Microsoft Graph User.Read delegated permission
      required_resource_access = [
        {
          resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
          resource_access = [
            {
              id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
              type = "Scope"
            }
          ]
        }
      ]

      app_roles = [
        {
          allowed_member_types = ["User"]
          description          = "Read-only access to the application"
          display_name         = "Reader"
          id                   = var.reader_role_id
          is_enabled           = true
          value                = "App.Reader"
        }
      ]
    }
  }
}
