# Source: Kubernetes RBAC API v1
#   resource   : ClusterRoleBinding
#   create     : POST /apis/rbac.authorization.k8s.io/v1/clusterrolebindings  (synchronous)
#   read       : GET  /apis/rbac.authorization.k8s.io/v1/clusterrolebindings/{name}
#   update     : PUT  /apis/rbac.authorization.k8s.io/v1/clusterrolebindings/{name}
#   delete     : DELETE /apis/rbac.authorization.k8s.io/v1/clusterrolebindings/{name}

locals {
  subjects = [
    for s in var.subjects : merge(
      {
        kind     = s.kind
        name     = s.name
        apiGroup = s.api_group
      },
      s.namespace != null ? { namespace = s.namespace } : {},
    )
  ]

  body = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRoleBinding"
    metadata = merge(
      { name = var.name },
      length(var.labels) > 0 ? { labels = var.labels } : {},
    )
    roleRef = {
      apiGroup = var.role_ref.api_group
      kind     = var.role_ref.kind
      name     = var.role_ref.name
    }
    subjects = local.subjects
  }
}

resource "rest_resource" "cluster_role_binding" {
  path          = "${var.cluster_endpoint}/apis/rbac.authorization.k8s.io/v1/clusterrolebindings"
  create_method = "POST"
  update_method = "PUT"

  read_path   = "${var.cluster_endpoint}/apis/rbac.authorization.k8s.io/v1/clusterrolebindings/${var.name}"
  update_path = "${var.cluster_endpoint}/apis/rbac.authorization.k8s.io/v1/clusterrolebindings/${var.name}"
  delete_path = "${var.cluster_endpoint}/apis/rbac.authorization.k8s.io/v1/clusterrolebindings/${var.name}"

  header = {
    Authorization = "Bearer ${var.cluster_token}"
  }

  body = local.body

  output_attrs = toset([
    "metadata.name",
    "metadata.uid",
  ])
}
