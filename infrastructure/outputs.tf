output "kind_cluster_name" {
  value = kind_cluster.default.name
}

output "kubeconfig" {
  value = kind_cluster.default.kubeconfig
}

output "endpoint" {
  value = kind_cluster.default.endpoint
}

output "client_key" {
  value = kind_cluster.default.client_key
}

output "argocd_admin_password" {
  description = "ArgoCD Admin Password"
  value = "Run: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}
