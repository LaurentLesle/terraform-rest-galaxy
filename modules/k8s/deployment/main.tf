# Source: Kubernetes Apps API v1
#   resource   : Deployment
#   create     : POST /apis/apps/v1/namespaces/{namespace}/deployments  (synchronous)
#   read       : GET  /apis/apps/v1/namespaces/{namespace}/deployments/{name}
#   update     : PUT  /apis/apps/v1/namespaces/{namespace}/deployments/{name}
#   delete     : DELETE /apis/apps/v1/namespaces/{namespace}/deployments/{name}

locals {
  match_labels = merge(
    { app = var.name },
    var.labels,
  )

  tolerations = [
    for t in var.tolerations : merge(
      { key = t.key, operator = t.operator },
      t.value != null ? { value = t.value } : {},
      t.effect != null ? { effect = t.effect } : {},
    )
  ]

  container = merge(
    {
      name  = var.name
      image = var.image
    },
    var.container_port != null ? {
      ports = [{ containerPort = var.container_port }]
    } : {},
    length(var.env) > 0 ? {
      env = [for k, v in var.env : { name = k, value = v }]
    } : {},
    var.command != null ? { command = var.command } : {},
    var.args != null ? { args = var.args } : {},
  )

  pod_spec = merge(
    { containers = [local.container] },
    var.service_account_name != null ? { serviceAccountName = var.service_account_name } : {},
    length(var.node_selector) > 0 ? { nodeSelector = var.node_selector } : {},
    length(local.tolerations) > 0 ? { tolerations = local.tolerations } : {},
  )

  body = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    spec = {
      replicas = var.replicas
      selector = {
        matchLabels = local.match_labels
      }
      template = {
        metadata = {
          labels = merge(local.match_labels, var.pod_labels)
        }
        spec = local.pod_spec
      }
    }
  }
}

resource "rest_resource" "deployment" {
  path          = "${var.cluster_endpoint}/apis/apps/v1/namespaces/${var.namespace}/deployments"
  create_method = "POST"
  update_method = "PUT"

  read_path   = "${var.cluster_endpoint}/apis/apps/v1/namespaces/${var.namespace}/deployments/${var.name}"
  update_path = "${var.cluster_endpoint}/apis/apps/v1/namespaces/${var.namespace}/deployments/${var.name}"
  delete_path = "${var.cluster_endpoint}/apis/apps/v1/namespaces/${var.namespace}/deployments/${var.name}"

  header = {
    Authorization = "Bearer ${var.cluster_token}"
  }

  body = local.body

  output_attrs = toset([
    "metadata.name",
    "metadata.namespace",
    "metadata.uid",
    "status.availableReplicas",
    "status.readyReplicas",
  ])
}
