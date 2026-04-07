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

variable "load_balancer_name" {
  type        = string
  description = "The name of the load balancer."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "sku_name" {
  type        = string
  description = "The SKU name (Basic, Standard, Gateway)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sku_tier" {
  type        = string
  default     = null
  description = "The SKU tier (Regional, Global)."
}

variable "frontend_ip_configurations" {
  type = list(object({
    name                         = string
    subnet_id                    = optional(string)
    private_ip_address           = optional(string)
    private_ip_allocation_method = optional(string)
    public_ip_address_id         = optional(string)
    zones                        = optional(list(string))
  }))
  default     = null
  description = "Frontend IP configurations."
}

variable "backend_address_pools" {
  type = list(object({
    name = string
  }))
  default     = null
  description = "Backend address pools."
}

variable "probes" {
  type = list(object({
    name                = string
    protocol            = string
    port                = number
    request_path        = optional(string)
    interval_in_seconds = optional(number)
    number_of_probes    = optional(number)
  }))
  default     = null
  description = "Health probes."
}

variable "load_balancing_rules" {
  type = list(object({
    name                      = string
    protocol                  = string
    frontend_port             = number
    backend_port              = number
    frontend_ip_config_name   = string
    backend_address_pool_name = string
    probe_name                = optional(string)
    idle_timeout_in_minutes   = optional(number)
    enable_floating_ip        = optional(bool)
    enable_tcp_reset          = optional(bool)
  }))
  default     = null
  description = "Load balancing rules."
}

variable "inbound_nat_rules" {
  type = list(object({
    name                      = string
    protocol                  = string
    frontend_port_range_start = number
    frontend_port_range_end   = number
    backend_port              = number
    frontend_ip_config_name   = string
    backend_address_pool_name = optional(string)
    idle_timeout_in_minutes   = optional(number)
    enable_floating_ip        = optional(bool)
    enable_tcp_reset          = optional(bool)
  }))
  default     = null
  description = "Inbound NAT rules."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
