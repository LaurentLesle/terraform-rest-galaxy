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
  description = "The name of the Job."
}

variable "namespace" {
  type        = string
  description = "The namespace in which to create the Job."
}

variable "image" {
  type        = string
  description = "The container image to use."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "backoff_limit" {
  type        = number
  default     = 0
  description = "Number of retries before marking the Job as failed."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the Job."
}

variable "pod_labels" {
  type        = map(string)
  default     = {}
  description = "Additional labels for the pod template."
}

variable "env" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the container."
}

variable "service_account_name" {
  type        = string
  default     = null
  description = "The ServiceAccount name to use for the pod."
}

variable "command" {
  type        = list(string)
  default     = null
  description = "Override the container entrypoint command."
}

variable "args" {
  type        = list(string)
  default     = null
  description = "Arguments to the container entrypoint."
}

variable "resource_requests" {
  type        = map(string)
  default     = { cpu = "100m", memory = "256Mi" }
  description = "Container resource requests."
}

variable "resource_limits" {
  type        = map(string)
  default     = { cpu = "500m", memory = "512Mi" }
  description = "Container resource limits."
}
