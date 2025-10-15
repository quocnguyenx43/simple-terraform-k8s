# Install Grafana via Helm
resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "8.6.0"
  create_namespace = false
  values           = [file("${path.module}/platforms/grafana-values.yaml")]

  # Give the chart extra time to complete admission jobs and webhooks
  timeout = 1200
  wait    = true

  depends_on = [kind_cluster.default]
}
