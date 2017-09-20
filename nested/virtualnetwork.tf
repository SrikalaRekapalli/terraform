
variable "ResourceGroup" {
description = "name of the resource group which we created the vnet"
}
variable "Location" {
description = "where the vnet is create"
}
variable "Vnet_AddressPrefix" {
description = "CIDR block for virtual network"
}
variable "Subnet1" {
description = "CIDR block for subnet1"
}
variable "Subnet2" {
description = "CIDR block for subnet2"
}
variable "Subnet3" {
description = "CIDR block for subnet3"
}
resource "azurerm_virtual_network" "Vnet" {
name = "Vnet"
address_space = ["${var.Vnet_AddressPrefix}"]
location = "${var.Location}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
}
resource "azurerm_subnet" "subnet1" {
name = "Subnet1"
address_prefix = "${var.Subnet1}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
virtual_network_name = "${azurerm_virtual_network.Vnet.name}"
}
resource "azurerm_subnet" "subnet2" {
name = "Subnet2"
address_prefix = "${var.Subnet2}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
virtual_network_name = "${azurerm_virtual_network.Vnet.name}"
}
resource "azurerm_subnet" "subnet3" {
name = "Subnet3"
address_prefix = "${var.Subnet3}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
virtual_network_name = "${azurerm_virtual_network.Vnet.name}"
}