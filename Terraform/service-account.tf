resource "google_service_account" "workload-identity-user-sa" {
  account_id   = "stackdriver"
  display_name = "Service Account For Workload Identity"
}


data "google_client_config" "current" {}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "service-a" {
  project = data.google_client_config.current.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}


resource "google_service_account_iam_member" "service-a" {
  service_account_id = google_service_account.workload-identity-user-sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[api/workload-identity-user-sa]"
}

