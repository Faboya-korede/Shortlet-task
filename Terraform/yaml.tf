resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "api"
  }
}

resource "kubernetes_service_account" "ksa" {
  metadata {
    name      = "stackdriver-ksa"
    namespace = "api"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.workload-identity-user-sa.email
    }
  }
}
