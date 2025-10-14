# Create a Kind cluster via Terraform
resource "kind_cluster" "default" {
  name           = var.cluster_name
  node_image     = "kindest/node:v1.30.2"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # Map to host for easy access (change if 80/443 busy)
      extra_port_mappings {
        host_port      = 80
        container_port = 31180
      }
      extra_port_mappings {
        host_port      = 443
        container_port = 31443
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}
