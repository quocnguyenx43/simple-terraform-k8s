# Install ingress-nginx Helm chart
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  namespace        = kubernetes_namespace.ingress_nginx.metadata[0].name
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.2"
  create_namespace = false
  values           = [file("${path.module}/platforms/ingress-nginx-values.yaml")]

  depends_on = [kind_cluster.default]
}
