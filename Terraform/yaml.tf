resource "kubernetes_namespace" "api" {
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

resource "kubernetes_deployment" "shortlet_api" {
  metadata {
    name      = "shortlet-api"
    namespace = kubernetes_namespace.api.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "shortlet-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "shortlet-api"
        }
      }

      spec {
        service_account_name =  kubernetes_service_account.ksa.metadata[0].name

        container {
          name  = "shortlet-api"
          image = "gcr.io/genial-diagram-434320-c8/shortlet-api:latest"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "shortlet_api" {
  metadata {
    name      = "shortlet-api"
    namespace = kubernetes_namespace.api.metadata[0].name
  }

  spec {
    selector = {
      app = "shortlet-api"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
