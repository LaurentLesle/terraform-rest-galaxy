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

module "root" {
  source = "../../../../"

  azure_resource_groups = {
    test = {
      subscription_id     = var.subscription_id
      resource_group_name = "test-rg-rest-module"
      location            = "westeurope"
    }
  }

  azure_key_vaults = {
    test = {
      subscription_id     = var.subscription_id
      resource_group_name = "ref:azure_resource_groups.test.resource_group_name"
      vault_name          = "kv-test-pe-001"
      location            = "ref:azure_resource_groups.test.location"
      tenant_id           = var.azure_tenant_id
    }
  }

  azure_virtual_networks = {
    test = {
      subscription_id     = var.subscription_id
      resource_group_name = "ref:azure_resource_groups.test.resource_group_name"
      location            = "ref:azure_resource_groups.test.location"
      address_space       = ["10.0.0.0/16"]
      subnets = [

        {

          name = "default",

          address_prefix = "10.0.1.0/24"

        }

      ]
    }
  }

  azure_private_endpoints = {
    minimum = {
      subscription_id         = var.subscription_id
      resource_group_name     = "ref:azure_resource_groups.test.resource_group_name"
      private_endpoint_name   = "pe-test-001"
      location                = "ref:azure_resource_groups.test.location"
      subnet_id               = "ref:azure_virtual_networks.test.subnets.default.id"
      private_link_service_id = "ref:azure_key_vaults.test.id"
      group_ids               = ["vault"]
    }
  }
}
