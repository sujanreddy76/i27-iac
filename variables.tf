variable "vpc_name" {
    description = "Name of the vpc"
    type = string
  
}

variable "subnets" {
    description = "List of subnets to be created"
    type = list(object({
        name = string
        ip_cidr_range = string
        subnet_region = string
    }))
  
}

# variable of compute instances
variable "instances" {
    description = "Enter the details of the VM"
    type = map(object({
      instance_type = string
      zone = string
      subnet = string
      disk_size = number
    }))
  
}

#Variable for VM user name
variable "vm_user" {
    description = "user name to connect to GCE"
    type = string
  
}

#Source range
variable "source_ranges" {
    description = "source range for firewall"
    type = list(string) 
}


