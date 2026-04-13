variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT. Required when access_token is not set."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "The Azure tenant ID."
}

variable "client_id" {
  type        = string
  default     = null
  description = "The Azure app registration client ID."
}

variable "access_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Direct Azure access token for local dev."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "data_collection_rule_name" {
  type        = string
  description = "The name of the Data Collection Rule."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the Data Collection Rule."
}

variable "kind" {
  type        = string
  default     = null
  description = "The kind of DCR. Options: Linux, Windows, AgentDirectToStore, WorkspaceTransforms."
}

variable "destinations" {
  type        = any
  default     = null
  description = "Destinations where data will be sent. Includes logAnalytics, azureMonitorMetrics, etc."
}

variable "data_flows" {
  type = list(object({
    streams            = list(string)
    destinations       = list(string)
    transform_kql      = optional(string, null)
    output_stream      = optional(string, null)
    built_in_transform = optional(string, null)
  }))
  default     = null
  description = "Data flows defining how data moves from sources to destinations."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Data Collection Rule."
}
