output "kubernetes_cluster_host" {
  value       = google_container_cluster.gke.endpoint
  description = "GKE Cluster Host"
}
