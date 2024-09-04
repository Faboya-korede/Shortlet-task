resource "google_container_node_pool" "primary_nodes" {
  name               = "primary-node-pool"
  location           = var.cluster_location
  cluster            = google_container_cluster.primary.name
  initial_node_count = 1

  node_config {
    machine_type = "e2-small" 
    disk_size_gb = 100        

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
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
