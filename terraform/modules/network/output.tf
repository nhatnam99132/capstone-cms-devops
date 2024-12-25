output "vpc_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "public_subnets" {
  description = "Public subnets"
  value       = { for i, subnet in google_compute_subnetwork.public_subnet : i => subnet.ip_cidr_range }
}

output "private_subnets" {
  description = "Private subnets"
  value       = { for i, subnet in google_compute_subnetwork.private_subnet : i => subnet.ip_cidr_range }
}

output "public_subnets_name" {
  description = "Public subnets"
  value       = { for i, subnet in google_compute_subnetwork.public_subnet : i => subnet.name }
}

output "private_subnets_name" {
  description = "Private subnets"
  value       = { for i, subnet in google_compute_subnetwork.private_subnet : i => subnet.name }
}
