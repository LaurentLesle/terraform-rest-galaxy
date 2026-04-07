# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "firewall_name" {
  type        = string
  default     = null
  description = "The name of the Azure Firewall."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region for the Azure Firewall."
}

variable "sku_name" {
  type        = string
  description = "The SKU name (AZFW_VNet or AZFW_Hub)."
}

variable "sku_tier" {
  type        = string
  description = "The SKU tier (Standard, Premium, Basic)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "virtual_hub_id" {
  type        = string
  default     = null
  description = "The ARM resource ID of the Virtual Hub to which the firewall belongs."
}

variable "firewall_policy_id" {
  type        = string
  default     = null
  description = "The ARM resource ID of the Firewall Policy associated with this firewall."
}

variable "threat_intel_mode" {
  type        = string
  default     = null
  description = "The operation mode for Threat Intelligence (Alert, Deny, Off)."
}

variable "public_ip_count" {
  type        = number
  default     = null
  description = "The number of public IP addresses associated with the hub firewall."
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "A list of availability zones."
}

variable "ip_configurations" {
  type = list(object({
    name                 = string
    subnet_id            = optional(string)
    public_ip_address_id = optional(string)
    privateIPAddress     = optional(string)
  }))
  default     = null
  description = "IP configurations for VNet-based firewalls (AZFW_VNet). The first entry must include a subnet_id (AzureFirewallSubnet). Additional entries are for extra public IPs."
}

variable "additional_properties" {
  type        = map(string)
  default     = {}
  description = "Additional properties for the Azure Firewall (key-value pairs)."
}

variable "application_rule_collections" {
  type        = list(any)
  default     = []
  description = "Collection of application rule collections used by Azure Firewall."
}

variable "nat_rule_collections" {
  type        = list(any)
  default     = []
  description = "Collection of NAT rule collections used by Azure Firewall."
}

variable "network_rule_collections" {
  type        = list(any)
  default     = []
  description = "Collection of network rule collections used by Azure Firewall."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
