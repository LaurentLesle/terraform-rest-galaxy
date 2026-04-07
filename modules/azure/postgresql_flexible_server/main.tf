# Source: azure-rest-api-specs
#   spec_path : postgresql/resource-manager/Microsoft.DBforPostgreSQL
#   api_version: 2025-08-01
#   operation  : Servers_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : Servers_Delete          (DELETE, async)

locals {
  api_version = "2025-08-01"
  server_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DBforPostgreSQL/flexibleServers/${var.server_name}"

  # ── Auth config ──────────────────────────────────────────────────────────
  auth_config = (var.active_directory_auth != null || var.password_auth != null || var.auth_tenant_id != null) ? merge(
    var.active_directory_auth != null ? { activeDirectoryAuth = var.active_directory_auth } : {},
    var.password_auth != null ? { passwordAuth = var.password_auth } : {},
    var.auth_tenant_id != null ? { tenantId = var.auth_tenant_id } : {},
  ) : null

  # ── Storage ──────────────────────────────────────────────────────────────
  storage = merge(
    { storageSizeGB = var.storage_size_gb },
    var.storage_auto_grow != null ? { autoGrow = var.storage_auto_grow } : {},
    var.storage_tier != null ? { tier = var.storage_tier } : {},
  )

  # ── Backup ───────────────────────────────────────────────────────────────
  backup = (var.backup_retention_days != null || var.geo_redundant_backup != null) ? merge(
    var.backup_retention_days != null ? { backupRetentionDays = var.backup_retention_days } : {},
    var.geo_redundant_backup != null ? { geoRedundantBackup = var.geo_redundant_backup } : {},
  ) : null

  # ── High availability ───────────────────────────────────────────────────
  high_availability = var.ha_mode != null ? merge(
    { mode = var.ha_mode },
    var.ha_standby_availability_zone != null ? { standbyAvailabilityZone = var.ha_standby_availability_zone } : {},
  ) : null

  # ── Network ──────────────────────────────────────────────────────────────
  network = (var.delegated_subnet_id != null || var.private_dns_zone_id != null || var.public_network_access != null) ? merge(
    var.delegated_subnet_id != null ? { delegatedSubnetResourceId = var.delegated_subnet_id } : {},
    var.private_dns_zone_id != null ? { privateDnsZoneArmResourceId = var.private_dns_zone_id } : {},
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
  ) : null

  # ── Maintenance window ──────────────────────────────────────────────────
  maintenance_window = var.maintenance_window != null ? {
    customWindow = var.maintenance_window.custom_window
    startHour    = var.maintenance_window.start_hour
    startMinute  = var.maintenance_window.start_minute
    dayOfWeek    = var.maintenance_window.day_of_week
  } : null

  # ── Assemble properties ────────────────────────────────────────────────
  properties = merge(
    { version = var.server_version },
    { storage = local.storage },
    var.administrator_login != null ? { administratorLogin = var.administrator_login } : {},
    local.auth_config != null ? { authConfig = local.auth_config } : {},
    local.backup != null ? { backup = local.backup } : {},
    local.high_availability != null ? { highAvailability = local.high_availability } : {},
    local.network != null ? { network = local.network } : {},
    var.availability_zone != null ? { availabilityZone = var.availability_zone } : {},
    local.maintenance_window != null ? { maintenanceWindow = local.maintenance_window } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
      sku        = { name = var.sku_name, tier = var.sku_tier }
    },
    var.tags != null ? { tags = var.tags } : {},
  )

  # Password sent via ephemeral_body — merged into the PUT request but
  # never stored in state.  Keeps `properties` non-sensitive in the plan.
  ephemeral_body = var.administrator_login_password != null ? {
    properties = {
      administratorLoginPassword = var.administrator_login_password
    }
  } : null
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.DBforPostgreSQL"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

# ── Name availability pre-check ──────────────────────────────────────────────
resource "rest_operation" "check_name_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.DBforPostgreSQL/checkNameAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name = var.server_name
    type = "Microsoft.DBforPostgreSQL/flexibleServers"
  }

  output_attrs = toset(["nameAvailable", "reason", "message"])
}

resource "rest_resource" "postgresql_flexible_server" {
  path            = local.server_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  ephemeral_body = local.ephemeral_body

  output_attrs = toset([
    "properties.state",
    "properties.fullyQualifiedDomainName",
    "properties.version",
    "properties.minorVersion",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.DBforPostgreSQL is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    postgresql:\n      resource_provider_namespace: Microsoft.DBforPostgreSQL"
    }
    precondition {
      condition     = var.check_existance || rest_operation.check_name_availability[0].output.nameAvailable
      error_message = "PostgreSQL Flexible Server name '${var.server_name}' is not available: ${try(rest_operation.check_name_availability[0].output.message, "unknown reason")}."
    }
  }

  poll_create = {
    status_locator    = "body.properties.state"
    default_delay_sec = 30
    status = {
      success = "Ready"
      pending = ["Provisioning", "Starting", "Updating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.state"
    default_delay_sec = 30
    status = {
      success = "Ready"
      pending = ["Updating", "Restarting"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
