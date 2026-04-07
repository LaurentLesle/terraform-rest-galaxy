# AKS Automatic SKU — Requirements & Lessons Learned

## API Version: 2026-01-01

### Required Configuration for AKS Automatic

1. **agentPoolProfiles**: Must be provided (not null) with at least `name`, `mode`, `count`, `vm_size`
2. **count on agent pool**: Cannot be null — API rejects with "Required parameter agentPoolProfile.count is missing"
3. **availability_zones**: Required — AKS Automatic needs all 3 zones `["1","2","3"]`
4. **VM size**: Must support ephemeral OS disk (e.g., `Standard_D4ds_v5` has 150 GB cache; `Standard_D2ds_v5` does NOT — its cache is 0)
5. **outbound_type**: Cannot be `none` — use managed or userDefinedRouting
6. **vnet_subnet_id on agent pool**: Required for BYOVNET. Without it, AKS requires System Assigned Managed Identity which conflicts with BYO private DNS zone (which needs UserAssigned)
7. **publicNetworkAccess**: Must be `Enabled` — node auto-provisioning (implied by Automatic SKU) requires public network access
8. **apiServerAccessProfile.subnetId**: Required when using BYOVNET with VNet integration (enableVnetIntegration: true). Create a dedicated `/28` subnet with `Microsoft.ContainerService/managedClusters` delegation
9. **node_os_upgrade_channel**: Use `NodeImage` (not `SecurityPatch`)
10. **enable_image_cleaner**: Must be `true`. Do NOT set `intervalHours` in the body — let the API use its default. If explicitly set, the API may reject with "recommended values" error
11. **Defender**: Requires a Log Analytics workspace resource ID. Either create LAW first or disable Defender

### Resource Provider Requirements
- `Microsoft.PolicyInsights` must be registered — required for AKS deployment safeguards

### Region Considerations
- AKS Automatic requires regions with 3 availability zones for the chosen VM size
- Check subscription-level restrictions: `az vm list-skus --location <region> --size <vmSize> -o table`
- swedencentral works well (no restrictions); westeurope had subscription-level AZ restrictions (only zone 2)

### Quota
- Check regional vCPU quotas before deploying. 3 x D4ds_v5 = 12 cores; default limit may be 10

### Idempotency
- PostgreSQL flexible server location returns display name ("Sweden Central") instead of API name ("swedencentral"), causing 1 change on re-apply. This is a known Azure REST API behavior.

### Destroy
- Destroy works cleanly with proper resource ordering
- Previous issue with DNS zone links ordering was resolved (not seen in swedencentral deployment)
