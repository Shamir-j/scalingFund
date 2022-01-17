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

terraform {
  cloud {
    organization = "Zaam-Technologies"

    workspaces {
      name = "ScalingFund"
    }
  }
}


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
