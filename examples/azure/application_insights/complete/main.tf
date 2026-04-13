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

  azure_application_insights = {
    complete = {
      subscription_id                     = var.subscription_id
      resource_group_name                 = var.resource_group_name
      application_insights_name           = var.application_insights_name
      location                            = var.location
      kind                                = var.kind
      application_type                    = var.application_type
      workspace_resource_id               = var.workspace_resource_id
      retention_in_days                   = var.retention_in_days
      sampling_percentage                 = var.sampling_percentage
      disable_ip_masking                  = var.disable_ip_masking
      public_network_access_for_ingestion = var.public_network_access_for_ingestion
      public_network_access_for_query     = var.public_network_access_for_query
      ingestion_mode                      = var.ingestion_mode
      disable_local_auth                  = var.disable_local_auth
      force_customer_storage_for_profiler = var.force_customer_storage_for_profiler
      tags                                = var.tags
    }
  }
}
