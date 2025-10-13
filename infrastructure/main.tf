# Create a Kind cluster via Terraform
resource "kind_cluster" "default" {
  name           = "simple-cicd-pipelines"
  node_image     = "kindest/node:v1.30.2"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      extra_port_mappings {
        container_port = 30080
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 30443
        host_port      = 443
      }
    }
  }
}
