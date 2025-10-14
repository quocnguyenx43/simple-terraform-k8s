# Install Jenkins via Helm
resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = kubernetes_namespace.jenkins.metadata[0].name
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  create_namespace = false
  values           = [file("${path.module}/../helm/shared-values/jenkins-values.yaml")]

  depends_on = [helm_release.ingress_nginx]
}
