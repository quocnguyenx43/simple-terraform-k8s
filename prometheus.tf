# Install Prometheus via Helm
resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "62.2.0"
  create_namespace = false

  set {
    name  = "grafana.enabled"
    value = "false"
  }
}
