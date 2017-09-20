variable "ResourceGroup" {
description = "name of the resource group which we created the vnet"
default = "komaliTerraform"
}
variable "Location" {
description = "where the vnet is create"
default = "west us"
}
variable "Vnet_AddressPrefix" {
description = "CIDR block for virtual network"
default  = "10.0.0.0/16"
}
variable "Subnet1" {
description = "CIDR block for subnet1"
default = "10.0.1.0/24"
}
variable "Subnet2" {
description = "CIDR block for subnet2"
default = "10.0.2.0/24"
}
variable "Subnet3" {
description = "CIDR block for subnet3"
default = "10.0.3.0/24"
}