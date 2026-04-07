# ── Scope ────────────────────────────────────────────────────────────────────

variable "organization" {
  type        = string
  description = "The GitHub organization name."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
  description = "Name of the hosted runner (1-64 chars, alphanumeric, '.', '-', '_')."
}

variable "image_id" {
  type        = string
  description = "The image ID (e.g. 'ubuntu-22.04', 'ubuntu-24.04')."
}

variable "image_source" {
  type        = string
  default     = "github"
  description = "The image source: github, partner, or custom."
}

variable "size" {
  type        = string
  description = "The machine size (e.g. '4-core', '8-core', '16-core')."
}

variable "runner_group_id" {
  type        = number
  description = "The numeric ID of the runner group to add this runner to."
}

# ── Optional ──────────────────────────────────────────────────────────────────

variable "maximum_runners" {
  type        = number
  default     = null
  description = "Maximum number of runners to scale up to. Limits cost."
}

variable "enable_static_ip" {
  type        = bool
  default     = null
  description = "Whether to create the runner with a static public IP."
}
