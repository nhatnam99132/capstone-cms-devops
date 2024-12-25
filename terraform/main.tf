terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name     = "${random_id.default.hex}-terraform-remote-backend"
  location = var.region

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  # You can store the template in a file and use the templatefile function for
  # more modularity, if you prefer, instead of storing the template inline as
  # we do here.
  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.default.name}"
    }
  }
  EOT
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",   
    "container.googleapis.com", 
    "iam.googleapis.com"       
  ])
  project = var.project_id
  service = each.key

  disable_on_destroy = false 
}

module "network" {
  source               = "./modules/network"
  region               = var.region
  network_name         = var.network_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "gke_cluster" {
  source = "./modules/gke"

  cluster_name = "devops-gke-cluster"
  region       = var.region
  network_name = module.network.vpc_id
  private_subnet_1  = module.network.private_subnets_name[1]
  private_subnet_2  = module.network.private_subnets_name[0]
  node_pool_1_count = 1
  disk_size_gb = 50
  depends_on = [
    module.network.public_subnets
  ]
}
