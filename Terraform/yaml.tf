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

# Create an Nginx Deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    namespace = "api"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}


# Expose the Nginx Deployment as a Service
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = "api"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_service" "nginx_ingress_controller" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "api"
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "nginx"
    }

    port {
      name        = "http"      # Add a name for port 80
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    port {
      name        = "https"     # Add a name for port 443
      protocol    = "TCP"
      port        = 443
      target_port = 443
    }
  }
}
