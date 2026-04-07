# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the ExpressRoute circuit peering."
  value       = local.peering_path
}

output "name" {
  description = "The name of the peering (plan-time, echoes input)."
  value       = var.peering_name
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the peering."
  value       = try(rest_resource.express_route_circuit_peering.output.properties.provisioningState, null)
}

output "azure_asn" {
  description = "The Azure ASN."
  value       = try(rest_resource.express_route_circuit_peering.output.properties.azureASN, null)
}

output "primary_azure_port" {
  description = "The primary Azure port."
  value       = try(rest_resource.express_route_circuit_peering.output.properties.primaryAzurePort, null)
}

output "secondary_azure_port" {
  description = "The secondary Azure port."
  value       = try(rest_resource.express_route_circuit_peering.output.properties.secondaryAzurePort, null)
}
