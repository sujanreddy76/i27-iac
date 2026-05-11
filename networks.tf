#Creating a VPC
resource "google_compute_network" "i27-ecommerce-vpc" {
  #arguments to build the VPC
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Create Multiple Subnets
resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
  count         = length(var.subnets)
  name          = var.subnets[count.index].name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region        = var.subnets[count.index].subnet_region
  network       = google_compute_network.i27-ecommerce-vpc.self_link
}