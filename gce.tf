# Generate a SSH Keypair
# tls_private_key resource will generate public and private keys
resource "tls_private_key" "i27-ecommerce-key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# Save the private key which we generated above(tls_private_key) to local file
# local_file resource Generates a local file with the given content
resource "local_file" "i27-ecommerce-key-private" {
  content = tls_private_key.i27-ecommerce-key.private_key_pem
  filename = "${path.module}/id_rsa" //${path.module} means: Current module directory.
  
}

# Save the public key which we generated above(tls_private_key) to local file
# local_file resource Generates a local file with the given content
resource "local_file" "i27-ecommerce-key-public" {
  content = tls_private_key.i27-ecommerce-key.public_key_openssh
  filename = "${path.module}/id_rsa.pub" //${path.module} means: Current module directory.
  
}

# Create Multiple Instances of GCE for our i27 infra
resource "google_compute_instance" "tf-vm-instance" {
  for_each     = var.instances
  name         = each.key
  machine_type = each.value.instance_type
  zone         = each.value.zone
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link #The URI of the image.
      size  = each.value.disk_size
      type  = "pd-standard"
    }
  }
  network_interface {
    network    = google_compute_network.i27-ecommerce-vpc.self_link
    subnetwork = each.value.subnet
    access_config {
      // Ephemeral public IP
    }
  }
  metadata = {
    # key format: username:public_key
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }

}

#Data block for image
data "google_compute_image" "ubuntu_image" {
  project = "ubuntu-os-cloud"
  name    = "ubuntu-2510-questing-amd64-v20260501"
}