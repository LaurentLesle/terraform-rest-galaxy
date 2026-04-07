terraform {
  required_providers {
    rest = {
      source  = "LaurentLesle/rest"
      version = "~> 1.0"
    }
  }
}

# Step 1 — Exchange the GitHub Actions OIDC JWT for an Azure access token
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
  # Direct token (local dev) takes precedence over OIDC-exchanged token (CI).
  azure_token = coalesce(
    var.access_token,
    try(rest_operation.access_token[0].output["access_token"], "")
  )
}

# Main provider — authenticated with the Azure access token
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

provider "rest" {
  alias    = "graph"
  base_url = "https://graph.microsoft.com"
  security = {
    http = {
      token = {
        token = var.graph_access_token
      }
    }
  }
}

locals {
  graph_token = coalesce(var.graph_access_token, "")
}

module "root" {
  source = "../../../../"

  graph_access_token = local.graph_token

  entraid_groups = {
    test = {
      display_name     = "tf-test-gm-group"
      mail_enabled     = false
      mail_nickname    = "tf-test-gm-group"
      security_enabled = true
    }
  }

  entraid_users = {
    test = {
      display_name        = "TF GM Test User"
      mail_nickname       = "tf-gm-test-user"
      user_principal_name = var.user_principal_name
      account_enabled     = true
      password_profile = {
        password                           = var.password
        force_change_password_next_sign_in = true
      }
    }
  }

  entraid_group_members = {
    test = {
      group_id  = "ref:entraid_groups.test.id"
      member_id = "ref:entraid_users.test.id"
    }
  }
}
