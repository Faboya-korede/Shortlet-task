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

resource "kubernetes_deployment" "shortlet_api" {
  metadata {
    name      = "shortlet-api"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
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
        service_account_name = "stackdriver-ksa"

        container {
          name  = "shortlet-api"
          image = "gcr.io/genial-diagram-434320-c8/shortlet-api"

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
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "shortlet-api"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_config_map" "config_map" {
  metadata {
    name      = "config-map"
    namespace = "api" # Replace with your namespace
  }

  data = var.config_map_values
}
