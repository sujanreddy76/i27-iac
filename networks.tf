#Creating a VPC
resource "google_compute_network" "i27-ecommerce-vpc" {
  #arguments to build the VPC
  name                    = "i27-ecommerce-vpc"
  auto_create_subnetworks = false
}