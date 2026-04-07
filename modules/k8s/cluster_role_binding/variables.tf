# ── Required ──────────────────────────────────────────────────────────────────

variable "cluster_endpoint" {
  type        = string
  description = "The kube-apiserver endpoint URL (e.g. https://127.0.0.1:6443)."
}

variable "cluster_token" {
  type        = string
  sensitive   = true
  description = "Bearer token for kube-apiserver authentication."
}

variable "name" {
  type        = string
  description = "The name of the ClusterRoleBinding."
}

variable "role_ref" {
  type = object({
    kind      = string
    name      = string
    api_group = optional(string, "rbac.authorization.k8s.io")
  })
  description = "The ClusterRole to bind to."
}

variable "subjects" {
  type = list(object({
    kind      = string
    name      = string
    api_group = optional(string, "rbac.authorization.k8s.io")
    namespace = optional(string, null)
  }))
  description = "The subjects (users, groups, service accounts) to bind."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the ClusterRoleBinding."
}
