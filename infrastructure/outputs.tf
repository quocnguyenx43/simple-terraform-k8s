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

output "jenkins_url" {
  value = "http://jenkins.localtest.me"
}

output "grafana_admin_password" {
  value = "admin"
}
