#Display both public and private IPs for all the instances created
output "instance_ips" {
  value = {
    for instance in google_compute_instance.tf-vm-instance :
    instance.name => {
        public_ip = instance.network_interface.0.access_config[0].nat_ip
        private_ip = instance.network_interface[0].network_ip
    }
  }
}

# # Public ip of ansible
# output "ansible_instance_public_ip" {
#     value = google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config[0].nat_ip
# }
# # Public ip of jenkins-master
# output "jenkins-master_instance_public_ip" {
#     value = google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip
# }
# # Public ip of jenkins-slave
# output "jenkins-slave_instance_public_ip" {
#     value = google_compute_instance.tf-vm-instance["jenkins-slave"].network_interface.0.access_config[0].nat_ip
# }

#Output to provide ssh command for better readability

#ssh -i id_rsa Arun@public_ip
output "ansible_ssh_command" {
    value = "To connect to ansible, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config[0].nat_ip}"
}
output "jenkins_master_ssh_command" {
    value = "To connect to jenkins-master, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip}"
}
output "jenkins_slave_ssh_command" {
    value = "To connect to jenkins-slave, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["jenkins-slave"].network_interface.0.access_config[0].nat_ip}"
}
output "sonarqube_ssh_command" {
    value = "To connect to sonarqube, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["sonarqube"].network_interface.0.access_config[0].nat_ip}"
}
output "docker_server_ssh_command" {
    value = "To connect to docker-server, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["docker-server"].network_interface.0.access_config[0].nat_ip}"
}