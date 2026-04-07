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

# Call the root module — all vars, passed as a single-entry map.
module "root" {
  source = "../../../../"

  azure_storage_accounts = {
    complete = {
      subscription_id                 = var.subscription_id
      resource_group_name             = var.resource_group_name
      account_name                    = var.account_name
      sku_name                        = var.sku_name
      kind                            = var.kind
      location                        = var.location
      tags                            = var.tags
      https_traffic_only_enabled      = var.https_traffic_only_enabled
      minimum_tls_version             = var.minimum_tls_version
      allow_blob_public_access        = var.allow_blob_public_access
      allow_shared_key_access         = var.allow_shared_key_access
      public_network_access           = var.public_network_access
      default_to_oauth_authentication = var.default_to_oauth_authentication
      allow_cross_tenant_replication  = var.allow_cross_tenant_replication
    }
  }
}
