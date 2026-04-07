# Source: Kubernetes API v1
#   resource   : ServiceAccount
#   create     : POST /api/v1/namespaces/{namespace}/serviceaccounts  (synchronous)
#   read       : GET  /api/v1/namespaces/{namespace}/serviceaccounts/{name}
#   update     : PUT  /api/v1/namespaces/{namespace}/serviceaccounts/{name}
#   delete     : DELETE /api/v1/namespaces/{namespace}/serviceaccounts/{name}

locals {
  body = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = merge(
      {
        name      = var.name
        namespace = var.namespace
      },
      length(var.labels) > 0 ? { labels = var.labels } : {},
      length(var.annotations) > 0 ? { annotations = var.annotations } : {},
    )
  }
}

resource "rest_resource" "service_account" {
  path          = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/serviceaccounts"
  create_method = "POST"
  update_method = "PUT"

  read_path   = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/serviceaccounts/${var.name}"
  update_path = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/serviceaccounts/${var.name}"
  delete_path = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/serviceaccounts/${var.name}"

  header = {
    Authorization = "Bearer ${var.cluster_token}"
  }

  body = local.body

  output_attrs = toset([
    "metadata.name",
    "metadata.namespace",
    "metadata.uid",
  ])
}
