variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}
variable "subnets" {
  description = "The list of subnets to be created"
  type = list(object({
    name          = string
    ip_cidr_range = string
    subnet_region = string
  }))
}
#Variable for Compute instances
variable "instances" {
  description = "Enter the details of the VM"
  type = map(object({
    instance_type = string
    zone          = string
    subnet        = string
    disk_size     = number
  }))

}
# VM User name
variable "vm_user" {
  description = "Username to connect to GCE"
  type        = string


}

# Firewall source ranges
variable "source_ranges" {
  description = "source ranges for firewall"
  type        = set(string)
}

# GKE CLuster name
variable "gke_cluster_details" {
  description = "Enter the details of the GKE cluster"
  type = object({
    name = string
    location = string
    initial_node_count = number
    machine_type = string
    disk_size_gb = number
  })
  
}
