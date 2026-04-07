# ── Helm Release (via rest provider — native Helm v4 SDK) ──────────────

resource "rest_helm_release" "this" {
  name                     = var.name
  namespace                = var.namespace
  chart                    = var.chart
  repository               = var.repository
  version                  = var.chart_version
  values                   = var.values
  set                      = length(var.set) > 0 ? var.set : null
  set_sensitive            = length(var.set_sensitive) > 0 ? var.set_sensitive : null
  kubeconfig_path          = var.kubeconfig_path
  kube_context             = var.kube_context
  create_namespace         = var.create_namespace
  wait                     = var.wait
  timeout                  = var.timeout
  insecure_skip_tls_verify = var.insecure_skip_tls_verify
}
