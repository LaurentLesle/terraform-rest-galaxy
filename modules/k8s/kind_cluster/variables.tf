# ── Required ──────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
  description = "The name of the kind cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version to use (maps to a kindest/node image tag)."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "node_pools" {
  type = map(object({
    role   = string
    count  = optional(number, 1)
    labels = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = optional(string, "")
      effect = string
    })), [])
  }))
  default     = {}
  description = "Map of node pools. Each pool specifies a role (control-plane or worker), count, and optional labels/taints."
}

variable "networking" {
  type = object({
    api_server_port = optional(number, 6443)
    pod_subnet      = optional(string, null)
    service_subnet  = optional(string, null)
  })
  default     = {}
  description = "Networking configuration for the kind cluster."
}

variable "docker_available" {
  type        = bool
  default     = true
  description = "Whether Docker is running. Set automatically by tf.sh. When false, a precondition prevents kind cluster creation."
}
