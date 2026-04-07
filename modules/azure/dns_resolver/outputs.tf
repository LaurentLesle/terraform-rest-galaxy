output "id" {
  value       = local.resolver_path
  description = "The resource ID of the DNS resolver (plan-time)."
}

output "name" {
  value       = var.dns_resolver_name
  description = "The name of the DNS resolver."
}

output "provisioning_state" {
  value       = try(rest_resource.dns_resolver.output.properties.provisioningState, null)
  description = "The provisioning state of the DNS resolver."
}

output "inbound_endpoint_ips" {
  value = {
    for k, ep in rest_resource.inbound_endpoint :
    k => try(ep.output.properties.ipConfigurations[0].privateIpAddress, null)
  }
  description = "Map of inbound endpoint name to its private IP address."
}
