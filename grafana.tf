# Install Grafana via Helm
resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "8.6.0"
  create_namespace = false

  set {
    name  = "adminPassword"
    value = "admin"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
