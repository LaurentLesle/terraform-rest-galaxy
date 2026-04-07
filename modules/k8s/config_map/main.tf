# Source: Kubernetes API v1
#   resource   : ConfigMap
#   create     : POST /api/v1/namespaces/{namespace}/configmaps  (synchronous)
#   read       : GET  /api/v1/namespaces/{namespace}/configmaps/{name}
#   update     : PUT  /api/v1/namespaces/{namespace}/configmaps/{name}
#   delete     : DELETE /api/v1/namespaces/{namespace}/configmaps/{name}

locals {
  body = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = merge(
      {
        name      = var.name
        namespace = var.namespace
      },
      length(var.labels) > 0 ? { labels = var.labels } : {},
    )
    data = var.data
  }
}

resource "rest_resource" "config_map" {
  path          = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/configmaps"
  create_method = "POST"
  update_method = "PUT"

  read_path   = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/configmaps/${var.name}"
  update_path = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/configmaps/${var.name}"
  delete_path = "${var.cluster_endpoint}/api/v1/namespaces/${var.namespace}/configmaps/${var.name}"

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
