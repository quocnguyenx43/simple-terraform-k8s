# Install ArgoCD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.8.0"
  create_namespace = false
  values     = [file("${path.module}/../helm/shared-values/argocd-values.yaml")]

  depends_on = [kind_cluster.default]
}
