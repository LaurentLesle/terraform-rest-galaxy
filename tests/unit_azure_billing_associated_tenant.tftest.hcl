# Unit test — modules/azure/billing_associated_tenant
# Tests the sub-module in isolation (plan only, no ref resolution).
# Run: terraform test -filter=tests/unit_azure_billing_associated_tenant.tftest.hcl

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

run "plan_billing_associated_tenant" {
  command = plan

  module {
    source = "./modules/azure/billing_associated_tenant"
  }

  variables {
    billing_account_name          = "12345678:12345678-1234-1234-1234-123456789012_2024-01-01"
    tenant_id                     = "aaaabbbb-cccc-dddd-eeee-ffffffffffff"
    display_name                  = "Test Partner Tenant"
    billing_management_state      = "Active"
    provisioning_management_state = "NotRequested"
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Billing/billingAccounts/12345678:12345678-1234-1234-1234-123456789012_2024-01-01/associatedTenants/aaaabbbb-cccc-dddd-eeee-ffffffffffff"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.billing_account_name == "12345678:12345678-1234-1234-1234-123456789012_2024-01-01"
    error_message = "Billing account name output must echo input."
  }

  assert {
    condition     = output.tenant_id == "aaaabbbb-cccc-dddd-eeee-ffffffffffff"
    error_message = "Tenant ID output must echo input."
  }

  assert {
    condition     = output.display_name == "Test Partner Tenant"
    error_message = "Display name output must echo input."
  }

  # precheck_access defaults to false — access_check outputs should be null
  assert {
    condition     = output.access_check_write == null
    error_message = "access_check_write must be null when precheck_access is false."
  }

  assert {
    condition     = output.access_check_delete == null
    error_message = "access_check_delete must be null when precheck_access is false."
  }
}
