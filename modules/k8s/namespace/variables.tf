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
  description = "The name of the Kubernetes namespace."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the namespace."
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Annotations to apply to the namespace."
}
