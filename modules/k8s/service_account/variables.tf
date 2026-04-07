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
  description = "The name of the Kubernetes ServiceAccount."
}

variable "namespace" {
  type        = string
  description = "The namespace in which to create the ServiceAccount."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the ServiceAccount."
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Annotations to apply to the ServiceAccount."
}
