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

variable "circuit_name" {
  type        = string
  description = "The name of the ExpressRoute circuit."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "peering_name" {
  type        = string
  description = "The name of the peering (e.g. AzurePrivatePeering, AzurePublicPeering, MicrosoftPeering)."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "peering_type" {
  type        = string
  description = "The peering type (AzurePrivatePeering, AzurePublicPeering, MicrosoftPeering)."
}

variable "vlan_id" {
  type        = number
  description = "The VLAN ID."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "peer_asn" {
  type        = number
  default     = null
  description = "The peer ASN."
}

variable "primary_peer_address_prefix" {
  type        = string
  default     = null
  description = "The primary address prefix (/30 CIDR block for the primary link)."
}

variable "secondary_peer_address_prefix" {
  type        = string
  default     = null
  description = "The secondary address prefix (/30 CIDR block for the secondary link)."
}

variable "shared_key" {
  type        = string
  default     = null
  sensitive   = true
  description = "The shared key (MD5 hash for BGP authentication)."
}

variable "state" {
  type        = string
  default     = null
  description = "The peering state (Enabled or Disabled)."
}

variable "azure_asn" {
  type        = number
  default     = null
  description = "The Azure ASN."
}

variable "primary_azure_port" {
  type        = string
  default     = null
  description = "The primary port."
}

variable "secondary_azure_port" {
  type        = string
  default     = null
  description = "The secondary port."
}

variable "gateway_manager_etag" {
  type        = string
  default     = null
  description = "The GatewayManager Etag."
}

variable "route_filter_id" {
  type        = string
  default     = null
  description = "The ARM resource ID of the Route Filter."
}
