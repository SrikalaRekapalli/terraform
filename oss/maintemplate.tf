provider "azurerm" {
subscription_id = "${var.subscription_id}"
client_id       = "${var.client_id}"
client_secret   = "${var.client_secret}"
tenant_id       = "${var.tenant_id}"
}
resource "azurerm_resource_group" "ResourceGroup" {
name = "${var.ResourceGroup}"
location = "${var.Location}"
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