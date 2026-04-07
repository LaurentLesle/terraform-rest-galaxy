# ── Required ──────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
  description = "Helm release name."
}

variable "chart" {
  type        = string
  description = "Chart reference: local path, repo/chartname, or OCI URL."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "namespace" {
  type        = string
  default     = "default"
  description = "Kubernetes namespace for the release."
}

variable "repository" {
  type        = string
  default     = null
  description = "Chart repository URL."
}

variable "chart_version" {
  type        = string
  default     = null
  description = "Chart version constraint."
}

variable "values" {
  type        = string
  default     = null
  description = "JSON-encoded values to pass to the chart."
}

variable "set" {
  type        = map(string)
  default     = {}
  description = "Map of individual values to set (dot-path keys supported)."
}

variable "set_sensitive" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Map of sensitive values to set (stored encrypted in state)."
}

variable "kubeconfig_path" {
  type        = string
  default     = null
  description = "Path to the kubeconfig file."
}

variable "kube_context" {
  type        = string
  default     = null
  description = "Kubeconfig context to use."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it does not exist."
}

variable "wait" {
  type        = bool
  default     = true
  description = "Wait until all resources are ready."
}

variable "timeout" {
  type        = number
  default     = 600
  description = "Timeout in seconds for Helm operations."
}

variable "insecure_skip_tls_verify" {
  type        = bool
  default     = false
  description = "Skip TLS certificate verification for the K8s API server."
}
