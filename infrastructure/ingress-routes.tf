# Install ingress-routes Helm chart
resource "helm_release" "ingress_routes" {
  name             = "ingress-routes"
  namespace        = kubernetes_namespace.ingress_routes.metadata[0].name
  chart            = "${path.module}/ingress-routes"
  create_namespace = false
  values           = [file("${path.module}/ingress-routes/values.yaml")]
  force_update     = true

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.jenkins,
    helm_release.argocd
  ]
}
