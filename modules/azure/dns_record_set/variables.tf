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

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "zone_name" {
  type        = string
  description = "The name of the DNS zone."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "record_name" {
  type        = string
  description = "The name of the DNS record set relative to the zone (e.g. '@', 'www', 'mail')."
}

variable "record_type" {
  type        = string
  description = "The DNS record type (e.g. TXT, CNAME, MX, A, AAAA)."

  validation {
    condition     = contains(["A", "AAAA", "CNAME", "MX", "NS", "PTR", "SOA", "SRV", "TXT", "CAA"], var.record_type)
    error_message = "record_type must be one of: A, AAAA, CNAME, MX, NS, PTR, SOA, SRV, TXT, CAA."
  }
}

# ── Required body properties ──────────────────────────────────────────────────

variable "ttl" {
  type        = number
  default     = 3600
  description = "The TTL for the record set in seconds."
}

# ── Optional record type–specific properties ──────────────────────────────────

variable "txt_records" {
  type = list(object({
    value = list(string)
  }))
  default     = null
  description = "TXT records. Each entry contains a list of string values."
}

variable "cname_record" {
  type = object({
    cname = string
  })
  default     = null
  description = "CNAME record (only one allowed per record set)."
}

variable "mx_records" {
  type = list(object({
    preference = number
    exchange   = string
  }))
  default     = null
  description = "MX records."
}

variable "a_records" {
  type = list(object({
    ipv4Address = string
  }))
  default     = null
  description = "A records."
}

variable "aaaa_records" {
  type = list(object({
    ipv6Address = string
  }))
  default     = null
  description = "AAAA records."
}

variable "metadata" {
  type        = map(string)
  default     = null
  description = "Metadata key-value pairs for the record set."
}
