# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID. Used to verify resource provider registration."
}

# ── Scope ───────────────────────────────────────────────────────────────────────
# This resource uses a scope-based ARM path:
#   /{resourceUri}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}
# The resource_id is the full ARM ID of the target resource (VM, AKS node pool, etc.)

variable "resource_id" {
  type        = string
  description = "The full ARM resource ID of the target resource (e.g. VM, AKS node pool) to associate with a data collection rule or endpoint."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "association_name" {
  type        = string
  description = "The name of the association. Case insensitive."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "Description of the association."
}

variable "data_collection_rule_id" {
  type        = string
  default     = null
  description = "The resource ID of the data collection rule to associate. Mutually exclusive with data_collection_endpoint_id."
}

variable "data_collection_endpoint_id" {
  type        = string
  default     = null
  description = "The resource ID of the data collection endpoint to associate. Mutually exclusive with data_collection_rule_id."
}
