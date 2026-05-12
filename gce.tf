# Generate a SSH Keypair
# tls_private_key resource will generate public and private keys
resource "tls_private_key" "i27-ecommerce-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key which we generated above(tls_private_key) to local file
# local_file resource Generates a local file with the given content
resource "local_file" "i27-ecommerce-key-private" {
  content  = tls_private_key.i27-ecommerce-key.private_key_pem
  filename = "${path.module}/id_rsa" //${path.module} means: Current module directory.

}

# Save the public key which we generated above(tls_private_key) to local file
# local_file resource Generates a local file with the given content
resource "local_file" "i27-ecommerce-key-public" {
  content  = tls_private_key.i27-ecommerce-key.public_key_openssh
  filename = "${path.module}/id_rsa.pub" //${path.module} means: Current module directory.

}

# Create Multiple Instances of GCE for our i27 infra
resource "google_compute_instance" "tf-vm-instance" {
  for_each     = var.instances
  name         = each.key
  machine_type = each.value.instance_type
  zone         = each.value.zone
  # Below is for boot disk os
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link #The URI of the image.
      size  = each.value.disk_size
      type  = "pd-standard"
    }
  }
  # Below is for network configurations
  network_interface {
    network    = google_compute_network.i27-ecommerce-vpc.self_link
    subnetwork = google_compute_subnetwork.i27-ecommerce-subnets[each.value.subnet].self_link
    access_config {
      // Ephemeral public IP
    }
  }
  # Below is to place the public key inside the VM
  metadata = {
    # key format: username:public_key
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }

  # Connection block to connect to the instances
  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = var.vm_user
    private_key = tls_private_key.i27-ecommerce-key.private_key_pem
  }

  # file provisioner block to copy local file to remote inatances
  provisioner "file" {
    source      = each.key == "ansible" ? "ansible.sh" : "empty.sh"
    destination = each.key == "ansible" ? "/home/${var.vm_user}/ansible.sh" : "/home/${var.vm_user}/empty.sh"
  }

  # remote-exec provisioner to execute on the remote machine
  provisioner "remote-exec" {
    inline = [ 
      each.key == "ansible" ? "chmod +x /home/${var.vm_user}/ansible.sh && /home/${var.vm_user}/ansible.sh" : "echo 'Not an Ansible Instance'"
     ]
    
  }

  # File provisioner to copy private key to all the vm's
  provisioner "file" {
    source = "${path.module}/id_rsa"
    destination = "/home/${var.vm_user}/ssh-key"
    
  }

}

#Data block for image
data "google_compute_image" "ubuntu_image" {
  project = "ubuntu-os-cloud"
  name    = "ubuntu-2510-questing-amd64-v20260501"
}