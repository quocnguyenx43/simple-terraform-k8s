# Install Jenkins via Helm
resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = kubernetes_namespace.jenkins.metadata[0].name
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  create_namespace = false

  set {
    name  = "controller.admin.username"
    value = "admin"
  }

  set {
    name  = "controller.admin.password"
    value = "admin"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "controller.ingress.enabled"
    value = "false"
  }

  set {
    name  = "controller.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "controller.ingress.hostName"
    value = "jenkins.localtest.me"
  }

  set {
    name  = "controller.ingress.path"
    value = "/"
  }

  set {
    name  = "controller.serviceType"
    value = "ClusterIP"
  }

  depends_on = [helm_release.ingress_nginx]
}
