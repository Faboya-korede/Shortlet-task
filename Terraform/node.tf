resource "google_container_node_pool" "primary_nodes" {
  name               = "primary-node-pool"
  location           = var.cluster_location
  cluster            = google_container_cluster.primary.name
  initial_node_count = 1

  node_config {
    machine_type = "e2-small" # You can adjust this to suit your needs
    disk_size_gb = 100        # Size of the boot disk in GB

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = ["gke-node"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

}
