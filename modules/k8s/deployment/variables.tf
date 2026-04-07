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
  description = "The name of the Deployment."
}

variable "namespace" {
  type        = string
  description = "The namespace in which to create the Deployment."
}

variable "image" {
  type        = string
  description = "The container image to use."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "replicas" {
  type        = number
  default     = 1
  description = "The number of desired replicas."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the Deployment and its pod template."
}

variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "Node selector for pod scheduling."
}

variable "tolerations" {
  type = list(object({
    key      = string
    operator = optional(string, "Equal")
    value    = optional(string, null)
    effect   = optional(string, null)
  }))
  default     = []
  description = "Tolerations for pod scheduling."
}

variable "container_port" {
  type        = number
  default     = null
  description = "The container port to expose."
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

variable "pod_labels" {
  type        = map(string)
  default     = {}
  description = "Additional labels to apply to the pod template (merged with match labels)."
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
