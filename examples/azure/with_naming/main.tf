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

# ── Naming Convention ─────────────────────────────────────────────────────────
# Use the Azure/naming/azurerm module to generate standardised resource names.
# This keeps the naming convention in the example — the root module accepts
# explicit names only.

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"

  prefix = var.naming_prefix
  suffix = var.naming_suffix
}

# ── Root Module ───────────────────────────────────────────────────────────────
# Pass generated names from the naming module to the root module.

module "root" {
  source = "../../../"

  default_location = var.location

  azure_resource_groups = {
    main = {
      subscription_id     = var.subscription_id
      resource_group_name = module.naming.resource_group.name
      location            = var.location
    }
  }

  azure_storage_accounts = {
    main = {
      subscription_id     = var.subscription_id
      resource_group_name = module.naming.resource_group.name
      account_name        = module.naming.storage_account.name_unique
      sku_name            = "Standard_LRS"
      kind                = "StorageV2"
      location            = var.location
    }
  }

  azure_key_vaults = {
    main = {
      subscription_id           = var.subscription_id
      resource_group_name       = module.naming.resource_group.name
      vault_name                = module.naming.key_vault.name_unique
      location                  = var.location
      tenant_id                 = var.tenant_id
      enable_rbac_authorization = true
    }
  }
}
