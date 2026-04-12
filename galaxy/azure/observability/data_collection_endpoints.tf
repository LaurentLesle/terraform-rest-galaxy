# ── Data Collection Endpoints ──────────────────────────────────────────────────

variable "azure_data_collection_endpoints" {
  type = map(object({
    subscription_id                     = optional(string, null)
    resource_group_name                 = string
    data_collection_endpoint_name       = optional(string, null)
    location                            = optional(string, null)
    description                         = optional(string, null)
    public_network_access               = optional(string, "Enabled")
    kind                                = optional(string, null)
    identity_type                       = optional(string, null)
    identity_user_assigned_identity_ids = optional(list(string), null)
    tags                                = optional(map(string), null)
  }))
  description = "Map of Data Collection Endpoint instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. When location is omitted, var.default_location is used as the default."
  default     = {}
}

locals {
  azure_data_collection_endpoints = provider::rest::resolve_map(
    local._ctx_l0b,
    merge(try(local._yaml_raw.azure_data_collection_endpoints, {}), var.azure_data_collection_endpoints)
  )
  _dce_ctx = provider::rest::merge_with_outputs(local.azure_data_collection_endpoints, module.azure_data_collection_endpoints)
}

module "azure_data_collection_endpoints" {
  source   = "./modules/azure/data_collection_endpoint"
  for_each = local.azure_data_collection_endpoints

  depends_on = [module.azure_resource_groups, module.azure_resource_provider_registrations]

  subscription_id                     = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                 = each.value.resource_group_name
  data_collection_endpoint_name       = try(each.value.data_collection_endpoint_name, each.key)
  location                            = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  description                         = try(each.value.description, null)
  public_network_access               = try(each.value.public_network_access, "Enabled")
  kind                                = try(each.value.kind, null)
  identity_type                       = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids = try(each.value.identity_user_assigned_identity_ids, null)
  tags                                = try(each.value.tags, null)
  check_existance                     = var.check_existance
}
