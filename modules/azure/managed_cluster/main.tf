# Source: azure-rest-api-specs
#   spec_path : containerservice/resource-manager/Microsoft.ContainerService/aks
#   api_version: 2026-01-01
#   operation  : ManagedClusters_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : ManagedClusters_Delete          (DELETE, async)

locals {
  api_version  = "2026-01-01"
  cluster_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ContainerService/managedClusters/${var.cluster_name}"

  # ── Identity block ───────────────────────────────────────────────────────
  identity = merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  )

  # ── Agent pool profiles ──────────────────────────────────────────────────
  agent_pool_profiles = var.agent_pool_profiles != null ? [
    for pool in var.agent_pool_profiles : merge(
      { name = pool.name },
      pool.count != null ? { count = pool.count } : {},
      pool.vm_size != null ? { vmSize = pool.vm_size } : {},
      pool.os_disk_size_gb != null ? { osDiskSizeGB = pool.os_disk_size_gb } : {},
      pool.os_disk_type != null ? { osDiskType = pool.os_disk_type } : {},
      pool.os_type != null ? { osType = pool.os_type } : {},
      pool.os_sku != null ? { osSKU = pool.os_sku } : {},
      pool.mode != null ? { mode = pool.mode } : {},
      pool.min_count != null ? { minCount = pool.min_count } : {},
      pool.max_count != null ? { maxCount = pool.max_count } : {},
      pool.enable_auto_scaling != null ? { enableAutoScaling = pool.enable_auto_scaling } : {},
      pool.max_pods != null ? { maxPods = pool.max_pods } : {},
      pool.vnet_subnet_id != null ? { vnetSubnetID = pool.vnet_subnet_id } : {},
      pool.availability_zones != null ? { availabilityZones = pool.availability_zones } : {},
      pool.node_labels != null ? { nodeLabels = pool.node_labels } : {},
      pool.node_taints != null ? { nodeTaints = pool.node_taints } : {},
      pool.enable_node_public_ip != null ? { enableNodePublicIP = pool.enable_node_public_ip } : {},
      pool.type != null ? { type = pool.type } : {},
      pool.scale_set_priority != null ? { scaleSetPriority = pool.scale_set_priority } : {},
      pool.orchestrator_version != null ? { orchestratorVersion = pool.orchestrator_version } : {},
      pool.tags != null ? { tags = pool.tags } : {},
    )
  ] : null

  # ── Network profile ─────────────────────────────────────────────────────
  network_profile = merge(
    { networkPlugin = var.network_plugin },
    var.network_plugin_mode != null ? { networkPluginMode = var.network_plugin_mode } : {},
    var.network_dataplane != null ? { networkDataplane = var.network_dataplane } : {},
    var.network_policy != null ? { networkPolicy = var.network_policy } : {},
    var.service_cidr != null ? { serviceCidr = var.service_cidr } : {},
    var.dns_service_ip != null ? { dnsServiceIP = var.dns_service_ip } : {},
    var.pod_cidr != null ? { podCidr = var.pod_cidr } : {},
    var.outbound_type != null ? { outboundType = var.outbound_type } : {},
    var.load_balancer_sku != null ? { loadBalancerSku = var.load_balancer_sku } : {},
  )

  # ── API server access profile ───────────────────────────────────────────
  _api_server_private = var.enable_private_cluster ? merge(
    { enablePrivateCluster = true },
    var.private_dns_zone != null ? { privateDNSZone = var.private_dns_zone } : {},
    var.enable_private_cluster_public_fqdn != null ? { enablePrivateClusterPublicFQDN = var.enable_private_cluster_public_fqdn } : {},
    var.disable_run_command != null ? { disableRunCommand = var.disable_run_command } : {},
    var.enable_vnet_integration != null ? { enableVnetIntegration = var.enable_vnet_integration } : {},
    var.api_server_subnet_id != null ? { subnetId = var.api_server_subnet_id } : {},
  ) : null

  _api_server_public = !var.enable_private_cluster && var.authorized_ip_ranges != null ? {
    authorizedIPRanges = var.authorized_ip_ranges
  } : null

  api_server_access_profile = coalesce(local._api_server_private, local._api_server_public, null)

  # ── AAD profile ─────────────────────────────────────────────────────────
  aad_profile = var.aad_managed ? merge(
    {
      managed         = true
      enableAzureRBAC = var.aad_enable_azure_rbac
    },
    var.aad_admin_group_object_ids != null ? { adminGroupObjectIDs = var.aad_admin_group_object_ids } : {},
    var.aad_tenant_id != null ? { tenantID = var.aad_tenant_id } : {},
  ) : null

  # ── Security profile ───────────────────────────────────────────────────
  security_profile = merge(
    var.enable_workload_identity ? { workloadIdentity = { enabled = true } } : {},
    var.enable_defender ? {
      defender = merge(
        { securityMonitoring = { enabled = true } },
        var.defender_log_analytics_workspace_id != null ? { logAnalyticsWorkspaceResourceId = var.defender_log_analytics_workspace_id } : {},
      )
    } : {},
    var.enable_image_cleaner != null ? {
      imageCleaner = merge(
        { enabled = var.enable_image_cleaner },
        var.image_cleaner_interval_hours != null ? { intervalHours = var.image_cleaner_interval_hours } : {},
      )
    } : {},
  )

  # ── OIDC issuer profile ─────────────────────────────────────────────────
  oidc_issuer_profile = var.enable_oidc_issuer ? { enabled = true } : null

  # ── Auto-upgrade profile ───────────────────────────────────────────────
  auto_upgrade_profile = var.upgrade_channel != null ? merge(
    { upgradeChannel = var.upgrade_channel },
    var.node_os_upgrade_channel != null ? { nodeOSUpgradeChannel = var.node_os_upgrade_channel } : {},
  ) : null

  # ── Node provisioning profile ──────────────────────────────────────────
  node_provisioning_profile = var.node_provisioning_mode != null ? { mode = var.node_provisioning_mode } : null

  # ── Assemble properties ────────────────────────────────────────────────
  properties = merge(
    { networkProfile = local.network_profile },
    var.kubernetes_version != null ? { kubernetesVersion = var.kubernetes_version } : {},
    var.dns_prefix != null ? { dnsPrefix = var.dns_prefix } : {},
    var.node_resource_group != null ? { nodeResourceGroup = var.node_resource_group } : {},
    local.agent_pool_profiles != null ? { agentPoolProfiles = local.agent_pool_profiles } : {},
    local.api_server_access_profile != null ? { apiServerAccessProfile = local.api_server_access_profile } : {},
    local.aad_profile != null ? { aadProfile = local.aad_profile } : {},
    length(local.security_profile) > 0 ? { securityProfile = local.security_profile } : {},
    local.oidc_issuer_profile != null ? { oidcIssuerProfile = local.oidc_issuer_profile } : {},
    local.auto_upgrade_profile != null ? { autoUpgradeProfile = local.auto_upgrade_profile } : {},
    local.node_provisioning_profile != null ? { nodeProvisioningProfile = local.node_provisioning_profile } : {},
    var.disable_local_accounts ? { disableLocalAccounts = true } : {},
    var.enable_rbac ? { enableRBAC = true } : {},
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
      sku        = { name = var.sku_name, tier = var.sku_tier }
      identity   = local.identity
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.ContainerService"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "managed_cluster" {
  path            = local.cluster_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.fqdn",
    "properties.privateFQDN",
    "properties.oidcIssuerProfile.issuerURL",
    "properties.identityProfile.kubeletidentity.objectId",
    "properties.identityProfile.kubeletidentity.clientId",
    "identity.principalId",
    "identity.tenantId",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.ContainerService is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    container_service:\n      resource_provider_namespace: Microsoft.ContainerService"
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = ["Succeeded"]
      pending = ["Creating", "Updating", "Accepted"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Accepted"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = ["404"]
      pending = ["200", "202"]
    }
  }
}
