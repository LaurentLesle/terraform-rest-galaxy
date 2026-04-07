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

# Call the root module with a single user.
module "root" {
  source = "../../../../"

  graph_access_token = local.graph_token

  entraid_users = {
    complete = {
      display_name        = var.display_name
      mail_nickname       = var.mail_nickname
      user_principal_name = var.user_principal_name
      account_enabled     = true
      password_profile = {
        password                           = var.password
        force_change_password_next_sign_in = true
      }
      given_name = "Test"
      surname    = "User"
      department = "Engineering"
      job_title  = "Developer"
    }
  }
}
