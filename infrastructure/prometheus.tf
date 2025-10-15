# Install Prometheus via Helm
resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "62.2.0"
  create_namespace = false
  values           = [file("${path.module}/platforms/prometheus-values.yaml")]

  # Give the chart extra time to complete admission jobs and webhooks
  timeout = 1200
  wait    = true

  depends_on = [kind_cluster.default]
}
