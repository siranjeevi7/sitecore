variable "rgname" {
    description = "resource grouop name"
    default     = "TF-Demo"
}

variable "location" {
    description = "location name"
    default     = "East Us"

}

variable "vnet_name" {
     description = "name for vnet"
     default     = "tf_vnet"
}
variable "address_space" {
     default     = ["10.0.0.0/16"]
}
variable "subnet_name" {
     default     = "public_subnet"
}
 variable "address_prefix" {
      default     = "10.0.1.0/24"
}

variable "external_ip" {
	description = "Please enter the Public IP address to whitelist in Security group to connect the VM"
	default = "10.0.1.0/24"
}

variable "numbercount" {
    type          = number
    default       = 2
}