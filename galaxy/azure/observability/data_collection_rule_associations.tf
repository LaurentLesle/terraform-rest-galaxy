# ── Data Collection Rule Associations ─────────────────────────────────────────
# Terminal resource — not added to layer context (nothing references its outputs).

variable "azure_data_collection_rule_associations" {
  type = map(object({
    subscription_id             = optional(string, null)
    resource_id                 = string
    association_name            = optional(string, null)
    description                 = optional(string, null)
    data_collection_rule_id     = optional(string, null)
    data_collection_endpoint_id = optional(string, null)
  }))
  description = "Map of Data Collection Rule Association instances to create. Each map key acts as the for_each identifier. resource_id is the full ARM ID of the target resource (VM, AKS node pool, etc.)."
  default     = {}
}

locals {
  azure_data_collection_rule_associations = provider::rest::resolve_map(
    local._ctx_l3,
    merge(try(local._yaml_raw.azure_data_collection_rule_associations, {}), var.azure_data_collection_rule_associations)
  )
}

module "azure_data_collection_rule_associations" {
  source   = "./modules/azure/data_collection_rule_association"
  for_each = local.azure_data_collection_rule_associations

  depends_on = [
    module.azure_data_collection_rules,
    module.azure_data_collection_endpoints,
  ]

  subscription_id             = try(each.value.subscription_id, var.subscription_id)
  resource_id                 = each.value.resource_id
  association_name            = try(each.value.association_name, each.key)
  description                 = try(each.value.description, null)
  data_collection_rule_id     = try(each.value.data_collection_rule_id, null)
  data_collection_endpoint_id = try(each.value.data_collection_endpoint_id, null)
  check_existance             = var.check_existance
}
