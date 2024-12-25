resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  count                    = length(var.public_subnet_cidrs)
  name                     = "${var.network_name}-public-${count.index}"
  ip_cidr_range            = var.public_subnet_cidrs[count.index]
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_subnet" {
  count                    = length(var.private_subnet_cidrs)
  name                     = "${var.network_name}-private-${count.index}"
  ip_cidr_range            = var.private_subnet_cidrs[count.index]
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}
