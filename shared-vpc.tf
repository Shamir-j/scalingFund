resource "google_compute_shared_vpc_host_project" "host" {
  project = google_project.host-staging.number
}

resource "google_compute_shared_vpc_service_project" "service" {
  host_project    = local.host_project_id
  service_project = local.service_project_id

  depends_on = [google_compute_shared_vpc_host_project.host]
}


resource "google_compute_subnetwork_iam_binding" "binding" {
  project    = google_compute_shared_vpc_host_project.host.project
  region     = google_compute_subnetwork.private.region
  subnetwork = google_compute_subnetwork.private.name

  role = "roles/compute.networkUser"
  members = [
    "serviceAccount:${google_service_account.k8s-staging.email}",
    "serviceAccount:${google_project.k8s-staging.number}@cloudservices.gserviceaccount.com",
    "serviceAccount:service-${google_project.k8s-staging.number}@container-engine-robot.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "container-engine" {
  project = google_compute_shared_vpc_host_project.host.project
  role    = "roles/container.hostServiceAgentUser"

  members = [
    "serviceAccount:service-${google_project.k8s-staging.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
  depends_on = [google_project_service.service]
}