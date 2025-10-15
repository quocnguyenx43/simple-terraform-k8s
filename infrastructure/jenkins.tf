# Install Jenkins via Helm
resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = kubernetes_namespace.jenkins.metadata[0].name
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.8.98"
  create_namespace = false
  values           = [file("${path.module}/platforms/jenkins-values.yaml")]

  # Give the chart extra time to complete admission jobs and webhooks
  timeout = 1200
  wait    = true

  depends_on = [helm_release.ingress_nginx]
}
