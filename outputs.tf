# Display both public and private ips for all the instances created
output "instance_ips" {
  value = {
    for instance in google_compute_instance.tf-vm-instance :
    instance.name => {
      public_ip  = instance.network_interface.0.access_config.0.nat_ip
      private_ip = instance.network_interface.0.network_ip
    }
  }
}

# Output to provide ssh command for user to login.(ssh -i id_rsa karrireddy@public_ip_address)
output "ansible_ssh_command" {
  value = "To connect to ansible, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config.0.nat_ip}"
}

output "jenkins_master_ssh_command" {
  value = "To connect to jenkins, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config.0.nat_ip}"
}

output "jenkins_slave_ssh_command" {
  value = "To connect to jenkins, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["jenkins-slave"].network_interface.0.access_config.0.nat_ip}"
}
