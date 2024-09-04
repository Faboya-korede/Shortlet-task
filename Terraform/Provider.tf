terraform {
  required_version = ">= 1.0.0"


  backend "gcs" {
    bucket = "terraform-shortlet"
    prefix = "terraform.tfstate/"
  }


  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  #credentials = file("${path.module}/genial-diagram-434320-c8-f7c39559df46.json")
  region  = var.region
  project = var.project_id
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)


}

provider "random" {}
resource "random_id" "redeploy" {
  byte_length = 8
}