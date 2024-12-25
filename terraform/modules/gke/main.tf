


resource "google_compute_subnetwork" "custom" {
  name          = "gke-custom"
  ip_cidr_range = var.secondary_ip_range
  region        = var.region
  network       = var.network_name
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}


resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.zone
  networking_mode          = "VPC_NATIVE"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
  network                  = var.network_name
  subnetwork               = google_compute_subnetwork.custom.id
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = google_compute_subnetwork.custom.secondary_ip_range.0.range_name

  }
  enable_multi_networking = true
  datapath_provider       = "ADVANCED_DATAPATH"
  depends_on              = [google_compute_subnetwork.custom]
}

resource "google_container_node_pool" "primary_nodes_1" {
  name       = "nodepool-1"
  cluster    = google_container_cluster.primary.name
  location   = var.zone
  node_count = var.node_pool_1_count
  
  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_size_gb = var.disk_size_gb
    disk_type = var.disk_type
  }

  depends_on = [google_container_cluster.primary]
}