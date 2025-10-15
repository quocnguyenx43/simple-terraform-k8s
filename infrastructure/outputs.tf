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

# -----------------------------
# ArgoCD access info
# -----------------------------

output "argocd_port_forward_cmd" {
  description = "Port-forward ArgoCD server to localhost"
  value       = "kubectl -n argocd port-forward svc/argocd-server 8081:80"
}

output "argocd_url_forwarding" {
  description = "ArgoCD UI URL (via local port-forward)"
  value       = "http://localhost:8081"
}

output "argocd_url" {
  description = "ArgoCD UI URL"
  value       = "http://argocd.localtest.me"
}

output "argocd_username" {
  description = "ArgoCD admin username"
  value       = "admin"
}

output "argocd_admin_password" {
  description = "ArgoCD Admin Password"
  value = "Run: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

# -----------------------------
# Jenkins access info
# -----------------------------

output "jenkins_port_forward_cmd" {
  description = "Port-forward Jenkins to localhost"
  value       = "kubectl -n jenkins port-forward svc/jenkins 8082:8080"
}

output "jenkins_url_forwarding" {
  description = "Jenkins UI URL (via local port-forward)"
  value       = "http://localhost:8082"
}

output "jenkins_url" {
  description = "Jenkins UI URL"
  value       = "http://jenkins.localtest.me"
}

output "jenkins_username" {
  description = "Jenkins admin username"
  value       = "admin"
}

output "jenkins_password" {
  description = "Jenkins admin password (set in Helm values)"
  value       = "admin"
}

# -----------------------------
# Grafana (from kube-prometheus-stack) access info
# -----------------------------

output "grafana_port_forward_cmd" {
  description = "Port-forward Grafana service to localhost"
  value       = "kubectl -n monitoring port-forward svc/prometheus-grafana 8083:80"
}

output "grafana_url_forwarding" {
  description = "Grafana UI URL (via local port-forward)"
  value       = "http://localhost:8083"
}

output "grafana_url" {
  description = "Grafana UI URL"
  value       = "http://grafana.localtest.me"
}

output "grafana_username" {
  description = "Grafana admin username"
  value       = "admin"
}

output "grafana_password" {
  description = "Grafana admin password (set in Helm values)"
  value       = "admin"
}

# -----------------------------
# Prometheus access info
# -----------------------------

output "prometheus_port_forward_cmd" {
  description = "Port-forward Prometheus server to localhost"
  value       = "kubectl -n monitoring port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090"
}

output "prometheus_url_forwarding" {
  description = "Prometheus UI URL (via local port-forward)"
  value       = "http://localhost:9090"
}

output "prometheus_url" {
  description = "Prometheus UI URL"
  value       = "http://prometheus.localtest.me"
}

output "prometheus_auth" {
  description = "Prometheus UI auth (none by default)"
  value       = "No username/password by default"
}
