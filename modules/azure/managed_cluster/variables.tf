# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "cluster_name" {
  type        = string
  default     = null
  description = "The name of the managed cluster."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

# ── SKU ───────────────────────────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  default     = "Automatic"
  description = "The SKU name. Options: Base, Automatic."
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "The SKU tier. Options: Free, Standard, Premium."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "The identity type. Options: SystemAssigned, UserAssigned, None."
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned identity ARM resource IDs."
}

# ── Kubernetes ────────────────────────────────────────────────────────────────

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "The Kubernetes version. When null, the latest stable version is used."
}

variable "dns_prefix" {
  type        = string
  default     = null
  description = "The DNS prefix for the cluster."
}

variable "node_resource_group" {
  type        = string
  default     = null
  description = "The name of the resource group containing agent pool nodes."
}

# ── Network profile ──────────────────────────────────────────────────────────

variable "network_plugin" {
  type        = string
  default     = "azure"
  description = "Network plugin. Options: azure, kubenet, none."
}

variable "network_plugin_mode" {
  type        = string
  default     = "overlay"
  description = "Network plugin mode. Options: overlay."
}

variable "network_dataplane" {
  type        = string
  default     = "cilium"
  description = "Network dataplane. Options: azure, cilium."
}

variable "network_policy" {
  type        = string
  default     = "cilium"
  description = "Network policy. Options: none, calico, azure, cilium."
}

variable "service_cidr" {
  type        = string
  default     = null
  description = "The service CIDR."
}

variable "dns_service_ip" {
  type        = string
  default     = null
  description = "The DNS service IP."
}

variable "pod_cidr" {
  type        = string
  default     = null
  description = "The pod CIDR (used with overlay mode)."
}

variable "outbound_type" {
  type        = string
  default     = null
  description = "Outbound routing method. Options: loadBalancer, userDefinedRouting, managedNATGateway, none."
}

variable "load_balancer_sku" {
  type        = string
  default     = null
  description = "Load balancer SKU. Options: standard, basic."
}

# ── API server access profile ────────────────────────────────────────────────

variable "enable_private_cluster" {
  type        = bool
  default     = false
  description = "Whether to create the cluster as a private cluster."
}

variable "private_dns_zone" {
  type        = string
  default     = null
  description = "The private DNS zone mode or resource ID. Options: system, none, or a resource ID."
}

variable "enable_private_cluster_public_fqdn" {
  type        = bool
  default     = null
  description = "Whether to create additional public FQDN for private cluster."
}

variable "disable_run_command" {
  type        = bool
  default     = null
  description = "Whether to disable run command for the cluster."
}

variable "authorized_ip_ranges" {
  type        = list(string)
  default     = null
  description = "Authorized IP ranges for the API server."
}

variable "enable_vnet_integration" {
  type        = bool
  default     = null
  description = "Whether to enable API server VNet integration."
}

variable "api_server_subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for API server VNet integration."
}

# ── AAD profile ──────────────────────────────────────────────────────────────

variable "aad_managed" {
  type        = bool
  default     = true
  description = "Whether to enable managed AAD integration."
}

variable "aad_enable_azure_rbac" {
  type        = bool
  default     = true
  description = "Whether to enable Azure RBAC for Kubernetes authorization."
}

variable "aad_admin_group_object_ids" {
  type        = list(string)
  default     = null
  description = "AAD group object IDs that will have cluster-admin role."
}

variable "aad_tenant_id" {
  type        = string
  default     = null
  description = "The AAD tenant ID for authentication."
}

# ── Security profile ────────────────────────────────────────────────────────

variable "enable_workload_identity" {
  type        = bool
  default     = true
  description = "Whether to enable workload identity."
}

variable "enable_defender" {
  type        = bool
  default     = false
  description = "Whether to enable Microsoft Defender."
}

variable "defender_log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "Log Analytics workspace resource ID for Defender."
}

variable "enable_image_cleaner" {
  type        = bool
  default     = null
  description = "Whether to enable image cleaner."
}

variable "image_cleaner_interval_hours" {
  type        = number
  default     = null
  description = "Image cleaner interval in hours."
}

# ── OIDC issuer profile ──────────────────────────────────────────────────────

variable "enable_oidc_issuer" {
  type        = bool
  default     = true
  description = "Whether to enable the OIDC issuer."
}

# ── Auto-upgrade profile ────────────────────────────────────────────────────

variable "upgrade_channel" {
  type        = string
  default     = "stable"
  description = "The auto upgrade channel. Options: rapid, stable, patch, node-image, none."
}

variable "node_os_upgrade_channel" {
  type        = string
  default     = null
  description = "Node OS upgrade channel. Options: None, Unmanaged, NodeImage, SecurityPatch."
}

# ── Node provisioning profile ───────────────────────────────────────────────

variable "node_provisioning_mode" {
  type        = string
  default     = null
  description = "Node provisioning mode. Options: Manual, Auto. Automatic SKU defaults to Auto."
}

# ── Agent pool profiles ──────────────────────────────────────────────────────

variable "agent_pool_profiles" {
  type = list(object({
    name                  = string
    count                 = optional(number)
    vm_size               = optional(string)
    os_disk_size_gb       = optional(number)
    os_disk_type          = optional(string)
    os_type               = optional(string)
    os_sku                = optional(string)
    mode                  = optional(string, "System")
    min_count             = optional(number)
    max_count             = optional(number)
    enable_auto_scaling   = optional(bool)
    max_pods              = optional(number)
    vnet_subnet_id        = optional(string)
    availability_zones    = optional(list(string))
    node_labels           = optional(map(string))
    node_taints           = optional(list(string))
    enable_node_public_ip = optional(bool)
    type                  = optional(string, "VirtualMachineScaleSets")
    scale_set_priority    = optional(string)
    orchestrator_version  = optional(string)
    tags                  = optional(map(string))
  }))
  default     = null
  description = "Agent pool profiles. For AKS Automatic with node provisioning Auto, this can be null."
}

# ── Other cluster properties ─────────────────────────────────────────────────

variable "disable_local_accounts" {
  type        = bool
  default     = true
  description = "Whether to disable local accounts."
}

variable "enable_rbac" {
  type        = bool
  default     = true
  description = "Whether to enable Kubernetes RBAC."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Public network access. Options: Enabled, Disabled."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags."
}
