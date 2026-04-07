# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the server."
}

variable "server_name" {
  type        = string
  description = "The name of the PostgreSQL Flexible Server."
}

# ── Administrator identity ────────────────────────────────────────────────────

variable "object_id" {
  type        = string
  description = "Object ID of the Microsoft Entra principal to set as administrator."
}

variable "principal_type" {
  type        = string
  default     = "ServicePrincipal"
  description = "Type of Entra principal. Options: User, Group, ServicePrincipal, Unknown."
}

variable "principal_name" {
  type        = string
  description = "Display name of the Microsoft Entra principal."
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID in which the Entra principal exists."
}
