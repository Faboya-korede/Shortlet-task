resource "google_service_account" "workload-identity-user-sa" {
  account_id   = "stackdriver"
  display_name = "Service Account For Workload Identity"
}


data "google_client_config" "current" {}

resource "google_project_iam_member" "network_admin" {
  project = data.google_client_config.current.project
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}

resource "google_project_iam_member" "load_balancer_admin" {
  project = data.google_client_config.current.project
  role    = "roles/compute.loadBalancerAdmin"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}

resource "google_project_iam_member" "k8s_developer" {
  project = data.google_client_config.current.project
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}

resource "google_project_iam_member" "workload_identity_role" {
  project = data.google_client_config.current.project
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}
