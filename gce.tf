# Generate a SSH Keypair
# this will generate public and private keys
resource "tls_private_key" "i27-ecommerce-key" {
    algorithm = "RSA"
    rsa_bits = 2048
  
}

#Save the private key to local file
resource "local_file" "i27-ecommerce-key-private" {
    content = tls_private_key.i27-ecommerce-key.private_key_pem
    filename = "${path.module}/id_rsa"
}

#Save the public key to local file
resource "local_file" "i27-ecommerce-key-pub" {
    content = tls_private_key.i27-ecommerce-key.public_key_openssh
    filename = "${path.module}/id_rsa.pub"
}

#Create Multiple instances of GCE for our i27 infra
resource "google_compute_instance" "tf-vm-instance" {
    for_each = var.instances
    name = each.key
    machine_type = each.value.instance_type
    zone = each.value.zone
  #Below is for boot disk os
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
      size = each.value.disk_size
      type = "pd-standard"
    }
  }
  #Below is for network configurations
  network_interface {
    network = google_compute_network.i27-ecommerce-vpc.self_link
    subnetwork = each.value.subnet
    access_config {
      // Ephemeral public IP
    }
  } 
  #Below is to place the public key inside the gce vm 
  metadata = {
    #username:key
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }
  #Connection block to connect to instances
  connection {
    host = self.network_interface[0].access_config[0].nat_ip
    type = "ssh"
    user = var.vm_user
    #passowrd = *****
    private_key = tls_private_key.i27-ecommerce-key.private_key_pem
  }
  #Provisiner block to copy local file to remote machines(instances)
  provisioner "file" {
    source = each.key == "ansible" ? "ansible.sh" : "empty.sh"
    destination = each.key == "ansible" ? "/home/${var.vm_user}/ansible.sh" : "/home/${var.vm_user}/empty.sh" 
  }
  #remote-exec Provisioner block to execute on the remote machine
  provisioner "remote-exec" {
    inline = [ 
        each.key == "ansible" ? "chmod +x /home/${var.vm_user}/ansible.sh && /home/${var.vm_user}/ansible.sh" : "echo 'Not an Ansible Instance'"
     ] 
  }
  #file provisioner to copy private key to all the VM's
  provisioner "file" {
    source = "${path.module}/id_rsa"
    destination = "/home/${var.vm_user}/ssh-key"
    
  }
  
}

#Data block for image
data "google_compute_image" "ubuntu_image" {
    family = "ubuntu-2004-lts"
    project = "ubuntu-os-cloud"
  
}