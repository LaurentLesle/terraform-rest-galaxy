# Source: azure-rest-api-specs
#   spec_path : dns/resource-manager/Microsoft.Network/dns
#   api_version: 2018-05-01
#   operation  : RecordSets_CreateOrUpdate  (PUT, synchronous)
#   delete     : RecordSets_Delete          (DELETE, synchronous)

locals {
  api_version     = "2018-05-01"
  record_set_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/dnsZones/${var.zone_name}/${var.record_type}/${var.record_name}"

  properties = merge(
    { TTL = var.ttl },
    var.txt_records != null ? { TXTRecords = var.txt_records } : {},
    var.cname_record != null ? { CNAMERecord = var.cname_record } : {},
    var.mx_records != null ? { MXRecords = var.mx_records } : {},
    var.a_records != null ? { ARecords = var.a_records } : {},
    var.aaaa_records != null ? { AAAARecords = var.aaaa_records } : {},
    var.metadata != null ? { metadata = var.metadata } : {},
  )

  body = {
    properties = local.properties
  }
}

resource "rest_resource" "dns_record_set" {
  path            = local.record_set_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.fqdn",
  ])

  # PUT and DELETE are both synchronous — no polling needed.
}
