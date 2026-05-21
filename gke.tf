resource "google_container_cluster" "primary" {
  name               = var.gke_cluster_details.name
  location           = var.gke_cluster_details.location
  initial_node_count = var.gke_cluster_details.initial_node_count
  node_config {
  machine_type = var.gke_cluster_details.machine_type
  disk_size_gb = var.gke_cluster_details.disk_size_gb
  }
}  