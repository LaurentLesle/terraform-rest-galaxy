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

  azure_log_analytics_workspaces = {
    complete = {
      subscription_id                              = var.subscription_id
      resource_group_name                          = var.resource_group_name
      workspace_name                               = var.workspace_name
      location                                     = var.location
      sku_name                                     = var.sku_name
      retention_in_days                            = var.retention_in_days
      daily_quota_gb                               = var.daily_quota_gb
      public_network_access_for_ingestion          = var.public_network_access_for_ingestion
      public_network_access_for_query              = var.public_network_access_for_query
      features_disable_local_auth                  = var.features_disable_local_auth
      features_enable_data_export                  = var.features_enable_data_export
      features_enable_log_access_using_only_resource_permissions = var.features_enable_log_access_using_only_resource_permissions
      identity_type                                = var.identity_type
      tags                                         = var.tags
    }
  }
}
