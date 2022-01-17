resource "google_service_account" "k8s-staging" {
  project    = local.service_project_id
  account_id = "k8s-staging"

  depends_on = [google_project.k8s-staging]
}

resource "google_container_cluster" "gke" {
  name     = "gke"
  location = local.region
  project  = local.service_project_id

  networking_mode = "VPC_NATIVE"
  network         = google_compute_network.main.self_link
  subnetwork      = google_compute_subnetwork.private.self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ip-range"
    services_secondary_range_name = "services-ip-range"
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    identity_namespace = "${google_project.k8s-staging.project_id}.svc.id.goog"
  }

}

resource "google_container_node_pool" "general" {
  name       = "general"
  location   = local.region
  cluster    = google_container_cluster.gke.name
  project    = local.service_project_id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      role = "general"
    }
    machine_type = "e2-medium"

    service_account = google_service_account.k8s-staging.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# resource "kubernetes_service" "app" {
#   metadata {
#     name = "app"
#   }

#   spec {
#     selector = {
#       run = "app"
#     }

#     session_affinity = "None"

#     port {
#       protocol    = "TCP"
#       port        = 80
#       target_port = 8080
#     }

#     type             = "LoadBalancer"
#     load_balancer_ip = google_container_cluster.gke.endpoint
#   }
# }

# resource "kubernetes_deployment" "app" {
#   metadata {
#     name = "app"

#     labels = {
#       run = "app"
#     }
#   }
#   spec {
#     # progressDeadlineSeconds = 600
#     replicas = 1

#     strategy {
#       type = "RollingUpdate"

#       rolling_update {
#         max_surge       = 1
#         max_unavailable = 0
#       }
#     }

#     selector {
#       match_labels = {
#         run = "app"
#       }
#     }

#     template {
#       metadata {
#         name = "app"
#         labels = {
#           run = "app"
#         }
#       }

#       spec {
#         container {
#           image = "shamirj/smarthotel-client"
#           name  = "app"

#           port {
#             container_port = 8080
#           }
#         }
#       }
#     }
#   }
# }

# output "public_url" {
#   value = "http://${google_compute_address.public_lb_ip.address}"
# }
