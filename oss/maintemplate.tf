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
resource "azurerm_network_security_group" "Nsg" {
  name                = "nsg"
  location            = "${var.Location}"
  resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
}
resource "azurerm_network_security_rule" "SSH" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.Subnet1}"
  destination_address_prefix  = "${var.Subnet1}"
  resource_group_name         = "${azurerm_resource_group.ResourceGroup.name}"
  network_security_group_name = "${azurerm_network_security_group.Nsg.name}"
}
resource "random_id" "dns" {
  keepers = {
    dnsid = "${var.DynamicDNS}"
  }
  byte_length = 8
}
resource "azurerm_public_ip" "DyanamicIP" {
  name                         = "DynamicIP2"
  location                     = "${var.Location}"
  resource_group_name          = "${azurerm_resource_group.ResourceGroup.name}"
  public_ip_address_allocation = "${var.DynamicIP}"
  domain_name_label = "saf${random_id.dns.hex}"
}