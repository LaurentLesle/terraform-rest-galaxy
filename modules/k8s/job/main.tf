# Source: Kubernetes Batch API v1
#   resource   : Job
#   create     : POST /apis/batch/v1/namespaces/{namespace}/jobs  (async — polls status.succeeded)
#   read       : GET  /apis/batch/v1/namespaces/{namespace}/jobs/{name}
#   delete     : DELETE /apis/batch/v1/namespaces/{namespace}/jobs/{name}

locals {
  container = merge(
    {
      name  = var.name
      image = var.image
      resources = {
        requests = var.resource_requests
        limits   = var.resource_limits
      }
    },
    length(var.env) > 0 ? {
      env = [for k, v in var.env : { name = k, value = v }]
    } : {},
    var.command != null ? { command = var.command } : {},
    var.args != null ? { args = var.args } : {},
  )

  pod_spec = merge(
    {
      containers    = [local.container]
      restartPolicy = "Never"
    },
    var.service_account_name != null ? { serviceAccountName = var.service_account_name } : {},
  )

  body = {
    apiVersion = "batch/v1"
    kind       = "Job"
    metadata = {
      name      = var.name
      namespace = var.namespace
      labels    = merge({ app = var.name }, var.labels)
    }
    spec = {
      backoffLimit = var.backoff_limit
      template = {
        metadata = {
          labels = merge({ app = var.name }, var.labels, var.pod_labels)
        }
        spec = local.pod_spec
      }
    }
  }
}

resource "rest_resource" "job" {
  path          = "${var.cluster_endpoint}/apis/batch/v1/namespaces/${var.namespace}/jobs"
  create_method = "POST"

  read_path   = "${var.cluster_endpoint}/apis/batch/v1/namespaces/${var.namespace}/jobs/${var.name}"
  delete_path = "${var.cluster_endpoint}/apis/batch/v1/namespaces/${var.namespace}/jobs/${var.name}"

  header = {
    Authorization = "Bearer ${var.cluster_token}"
  }

  body = local.body

  # Jobs are immutable — any spec change must delete + recreate
  force_new_attrs = toset(["spec"])

  # Wait for the Job to complete after creation
  poll_create = {
    status_locator    = "body.status.succeeded"
    default_delay_sec = 10
    status = {
      success = "1"
      pending = ["0"]
    }
  }

  output_attrs = toset([
    "metadata.name",
    "metadata.namespace",
    "metadata.uid",
    "status.succeeded",
    "status.failed",
    "status.startTime",
    "status.completionTime",
  ])

  lifecycle {
    # Jobs are immutable – force recreation on any field change
    create_before_destroy = false
  }
}
