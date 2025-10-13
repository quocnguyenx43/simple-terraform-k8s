# Create namespace for ingress-nginx
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }

  depends_on = [kind_cluster.default]
}

# Create namespace for ingress-routes
resource "kubernetes_namespace" "ingress_routes" {
  metadata {
    name = "ingress-routes"
  }

  depends_on = [kind_cluster.default]
}

# Create a namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [kind_cluster.default]
}

# Create a namespace for Jenkins
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }

  depends_on = [kind_cluster.default]
}

# Create a namespace for Monitoring
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [kind_cluster.default]
}
