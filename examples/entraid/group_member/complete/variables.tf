variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = null
}

variable "user_principal_name" {
  type        = string
  description = "UPN for the test user."
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Password for the test user."
}
