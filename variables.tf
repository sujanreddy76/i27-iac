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