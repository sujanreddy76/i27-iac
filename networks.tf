#Creating a VPC
resource "google_compute_network" "i27-ecommerce-vpc" {
  #arguments to build the VPC
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Create Multiple Subnets
resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
  for_each = {
    for subnet in var.subnets : subnet.name => subnet
  }
  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.subnet_region
  network       = google_compute_network.i27-ecommerce-vpc.self_link
}

#Create firewall
#Open ports: 80, 8080(jenkins), 22(ssh), 9000(sonarQube)
resource "google_compute_firewall" "i27-allow-ssh-http-jenkins-ports" {
  name    = "i27-allow-ssh-http-jenkins-ports"
  network = google_compute_network.i27-ecommerce-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "9000", "22"]
  }
  source_ranges = var.source_ranges
}