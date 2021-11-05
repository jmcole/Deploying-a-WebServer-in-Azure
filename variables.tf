variable "client" {
  description = "Client ID"
  default     = "JMC"
}

variable "packer_resource_group_name" {
  description = "Name of the resource group in which the Packer image will be created"
  default     = "myPackerImages"
}

variable "packer_image_name" {
  description = "Name of the Packer image"
  default     = "myPackerImage"
}

variable "resource_group_name" {
  description = "Name of the resource group in which the Packer image  will be created"
  default     = "myPackerImages"
}

variable "resource_group_name_vmss" {
  description = "Name of the resource group in which the vmss  will be created"
  default     = "vmss"
}

variable "location" {
  default     = "eastus"
  description = "Location where resources will be created"
}

variable "tags" {
  description = "Map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    Client = "JMC"
  }
}

variable "application_port" {
  description = "Port that you want to expose to the external load balancer"
  default     = 80
}

variable "admin_user" {
  description = "User name to use as the admin account on the VMs that will be part of the VM scale set"
  default     = "azureuser"
}

variable "admin_password" {
  description = "The default password"
  default = "password"
}

variable "vm_count" {
  description = "The number of instances to create."
  default     = 2
}
