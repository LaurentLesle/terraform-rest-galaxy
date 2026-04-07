# Source: Kubernetes API v1
#   resource   : Namespace
#   create     : POST /api/v1/namespaces  (synchronous)
#   read       : GET  /api/v1/namespaces/{name}
#   update     : PUT  /api/v1/namespaces/{name}
#   delete     : DELETE /api/v1/namespaces/{name}

locals {
  # Kubernetes automatically adds "kubernetes.io/metadata.name" to every namespace.
  # Include it here so the body matches the server-side state and avoids drift.
  all_labels = merge(
    { "kubernetes.io/metadata.name" = var.name },
    var.labels,
  )

  body = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = merge(
      { name = var.name },
      { labels = local.all_labels },
      length(var.annotations) > 0 ? { annotations = var.annotations } : {},
    )
  }
}

resource "rest_resource" "namespace" {
  path          = "${var.cluster_endpoint}/api/v1/namespaces"
  create_method = "POST"
  update_method = "PUT"

  read_path   = "${var.cluster_endpoint}/api/v1/namespaces/${var.name}"
  update_path = "${var.cluster_endpoint}/api/v1/namespaces/${var.name}"
  delete_path = "${var.cluster_endpoint}/api/v1/namespaces/${var.name}"

  header = {
    Authorization = "Bearer ${var.cluster_token}"
  }

  body = local.body

  output_attrs = toset([
    "metadata.name",
    "metadata.uid",
    "status.phase",
  ])
}
