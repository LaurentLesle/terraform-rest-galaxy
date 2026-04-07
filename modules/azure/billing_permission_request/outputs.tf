locals {
  _is_permission_request = var.provisioning_billing_request_id != null
  _res                   = local._is_permission_request ? try(rest_resource.billing_permission_request[0], null) : try(rest_resource.billing_request_approval[0], null)
}

output "id" {
  description = "The request path."
  value       = try(local._res.id, null)
}

output "status" {
  description = "The approval status."
  value       = try(local._res.output.properties.status, var.status)
}

output "output" {
  description = "The full API response."
  value       = try(local._res.output, null)
}
