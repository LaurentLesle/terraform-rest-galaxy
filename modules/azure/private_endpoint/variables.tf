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

variable "private_endpoint_name" {
  type        = string
  description = "The name of the private endpoint."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "subnet_id" {
  type        = string
  description = "The resource ID of the subnet to place the private endpoint in."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "custom_network_interface_name" {
  type        = string
  default     = null
  description = "Custom name for the network interface created by the private endpoint."
}

variable "private_link_service_connections" {
  type = list(object({
    name                    = string
    private_link_service_id = string
    group_ids               = optional(list(string))
    request_message         = optional(string)
  }))
  default     = null
  description = "Auto-approved private link service connections."
}

variable "manual_private_link_service_connections" {
  type = list(object({
    name                    = string
    private_link_service_id = string
    group_ids               = optional(list(string))
    request_message         = optional(string)
  }))
  default     = null
  description = "Manually-approved private link service connections."
}

variable "ip_configurations" {
  type = list(object({
    name               = string
    group_id           = optional(string)
    member_name        = optional(string)
    private_ip_address = string
  }))
  default     = null
  description = "Static IP configurations for the private endpoint."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

variable "private_dns_zone_group" {
  type = object({
    name                 = optional(string, "default")
    private_dns_zone_ids = list(string)
  })
  default     = null
  description = "DNS zone group to automatically register A records in private DNS zones."
}
