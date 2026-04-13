# Source: azure-rest-api-specs
#   spec_path : domainregistration/resource-manager/Microsoft.DomainRegistration/DomainRegistration
#   api_version: 2024-11-01
#   operation  : Domains_CreateOrUpdate  (PUT, async — location header polling)
#   delete     : Domains_Delete          (DELETE, synchronous)
#
# ⚠ BLOCKED on some subscriptions: The DomainRegistration reseller backend
#   returns DIRECT_CLIENT_CERT_AUTH_DISABLED on sandbox/lab subscriptions.
#   This is a subscription capability restriction, not an auth method issue.
#   The module works on production subscriptions with domain purchase enabled.
#   See ROADMAP.md for details.

locals {
  api_version = "2024-11-01"
  domain_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DomainRegistration/domains/${var.domain_name}"

  _build_contact = { for role, contact in {
    contactAdmin      = var.contact_admin
    contactBilling    = var.contact_billing
    contactRegistrant = var.contact_registrant
    contactTech       = var.contact_tech
    } : role => merge(
    {
      nameFirst = contact.first_name
      nameLast  = contact.last_name
      email     = contact.email
      phone     = contact.phone
    },
    contact.organization != null ? { organization = contact.organization } : {},
    contact.job_title != null ? { jobTitle = contact.job_title } : {},
    contact.fax != null ? { fax = contact.fax } : {},
    contact.middle_name != null ? { nameMiddle = contact.middle_name } : {},
    (contact.address_line1 != null && contact.city != null && contact.country != null && contact.postal_code != null && contact.state != null) ? {
      addressMailing = merge(
        {
          address1   = contact.address_line1
          city       = contact.city
          country    = contact.country
          postalCode = contact.postal_code
          state      = contact.state
        },
        contact.address_line2 != null ? { address2 = contact.address_line2 } : {},
      )
    } : {},
  ) }

  properties = merge(
    {
      contactAdmin      = local._build_contact["contactAdmin"]
      contactBilling    = local._build_contact["contactBilling"]
      contactRegistrant = local._build_contact["contactRegistrant"]
      contactTech       = local._build_contact["contactTech"]
      consent = {
        agreementKeys = var.consent_agreement_keys
        agreedBy      = var.consent_agreed_by
        agreedAt      = var.consent_agreed_at
      }
      privacy   = var.privacy
      autoRenew = var.auto_renew
    },
    var.dns_type != null ? { dnsType = var.dns_type } : {},
    var.dns_zone_id != null ? { dnsZoneId = var.dns_zone_id } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ─────────────────────────────────────

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.DomainRegistration"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

# ── Domain availability pre-check ────────────────────────────────────────────

resource "rest_operation" "check_domain_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.DomainRegistration/checkDomainAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name = var.domain_name
  }

  output_attrs = toset(["available", "domainType"])
}

resource "rest_resource" "app_service_domain" {
  path            = local.domain_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.registrationStatus",
    "properties.nameServers",
    "properties.expirationTime",
    "properties.dnsZoneId",
  ])

  lifecycle {
    precondition {
      condition     = contains(["Registered", "Registering"], data.rest_resource.provider_check.output.registrationState)
      error_message = "Resource provider Microsoft.DomainRegistration is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    domainregistration:\n      resource_provider_namespace: Microsoft.DomainRegistration"
    }
    precondition {
      condition     = var.check_existance || try(rest_operation.check_domain_availability[0].output.available, false)
      error_message = "Domain '${var.domain_name}' is not available for registration."
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = ["Succeeded"]
      pending = ["InProgress"]
    }
  }

  # DELETE is synchronous for App Service Domains.
}
