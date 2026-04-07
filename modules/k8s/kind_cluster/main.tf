# Source: tehcyx/kind provider
#   resource : kind_cluster
#   Creates a local Kubernetes cluster using kind (Kubernetes IN Docker).
#   Node pools are flattened into a list of kind nodes with roles, labels, and taints.

locals {
  # Flatten node pools into individual node entries
  nodes = flatten([
    for pool_key, pool in var.node_pools : [
      for i in range(pool.count) : {
        role   = pool.role
        labels = pool.labels
        taints = pool.taints
      }
    ]
  ])

  # Map kubernetes_version to kindest/node image tag
  node_image = "kindest/node:v${var.kubernetes_version}"

  # Build kubeadm config patch strings for labels and taints
  node_patches = {
    for idx, node in local.nodes : idx => (
      length(node.labels) > 0 || length(node.taints) > 0
      ? [
        join("\n", concat(
          [
            node.role == "control-plane" ? "kind: InitConfiguration" : "kind: JoinConfiguration",
            "nodeRegistration:",
          ],
          length(node.labels) > 0 ? [
            "  kubeletExtraArgs:",
            "    node-labels: \"${join(",", [for k, v in node.labels : "${k}=${v}"])}\"",
          ] : [],
          length(node.taints) > 0 ? flatten([
            ["  taints:"],
            [for t in node.taints : "  - key: ${t.key}\n    value: \"${t.value}\"\n    effect: ${t.effect}"],
          ]) : [],
        ))
      ]
      : []
    )
  }
}

resource "kind_cluster" "this" {
  name           = var.name
  node_image     = local.node_image
  wait_for_ready = true

  lifecycle {
    precondition {
      condition     = var.docker_available
      error_message = "Docker is not running. kind clusters require a running Docker daemon. Start Docker Desktop and retry."
    }
  }

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    networking {
      api_server_port = var.networking.api_server_port
      pod_subnet      = var.networking.pod_subnet
      service_subnet  = var.networking.service_subnet
    }

    dynamic "node" {
      for_each = local.nodes
      content {
        role                   = node.value.role
        image                  = local.node_image
        kubeadm_config_patches = local.node_patches[node.key]
      }
    }
  }
}
