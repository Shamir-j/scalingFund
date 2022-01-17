provider "google" {
  region = "us-west2"
}

resource "random_integer" "int" {
  min = 100
  max = 1000000
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.66"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

# terraform {
#   cloud {
#     organization = "Zaam-Technologies"

#     workspaces {
#       name = "ScalingFund"
#     }
#   }
# }


data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.gke.endpoint}"
  token = data.google_client_config.provider.access_token
  # client_certificate = base64decode(
  #   google_container_cluster.gke.master_auth[0].client_certificate
  # )
  # cluster_ca_certificate = base64decode(
  #   google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  # )
  # client_key = base64decode(
  #   google_container_cluster.gke.master_auth[0].client_key
  # )
}

# resource "google_compute_address" "public_lb_ip" {
#   name   = "example-lb-ip"
#   region = local.region
# }

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
#     load_balancer_ip = google_compute_address.public_lb_ip.address
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
#           image = "escoto/kotlinresthello"
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
