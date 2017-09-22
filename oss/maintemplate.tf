provider "azurerm" {
subscription_id = "${var.subscription_id}"
client_id       = "${var.client_id}"
client_secret   = "${var.client_secret}"
tenant_id       = "${var.tenant_id}"
}
variable "subscription_id" {
description = "name of the resource group which we created the vnet"
}
variable "client_id" {
description = "where the vnet is create"
}
variable "client_secret" {
description = "CIDR block for virtual network"
}
variable  "tenant_id"  {
description = "CIDR block for subnet1"
}
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
variable "DynamicIP" {
description =  "public_ip_address_allocation dynamic type"
}
variable "DynamicDNS" {
description = "dynamicip domain name label"
}
variable "storageAccType" {
description = "storage account type"
}
variable "uniqueid" {
description = "unique string"
}
variable "vmSize" {
description = "virtual machine size"
}
variable "os_type" {
description = "Type of OS on the existing vhd. Allowed values: 'windows' or 'linux'."
}
variable "vmName" {
description = "virtual machine name"
}
variable "userName" {
description = "virtual machine admin user name"
}
variable "password" {
description = "virtual machine admin password"
}
variable "existing_storage_acct" {
description = "The name of the storage account in which your existing VHD and image reside"
}
variable "existing_resource_group" {
description = "The name of the resource group in which your existing storage account with your existing VHD resides"
}
variable "source_img_uri" {
description = "Full URIs for one or more custom images (VHDs) that should be copied to the deployment storage account to spin up new VMs from them. URLs must be comma separated."
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
resource "random_id" "uniq" {
  keepers = {
    uniqueid = "${var.uniqueid}"
  }
  byte_length = 8
}
resource "azurerm_storage_account" "Storage" {
name                = "strg${random_id.uniq.hex}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
location     = "${var.Location}"
account_type = "${var.storageAccType}"
}
resource "azurerm_storage_container" "container" {
name                  = "stgcontainer"
resource_group_name   = "${azurerm_resource_group.ResourceGroup.name}"
storage_account_name  = "${azurerm_storage_account.Storage.name}"
container_access_type = "private"
}
resource "azurerm_public_ip" "DyanamicIP" {
name                         = "DynamicIP2"
location                     = "${var.Location}"
resource_group_name          = "${azurerm_resource_group.ResourceGroup.name}"
public_ip_address_allocation = "${var.DynamicIP}"
domain_name_label = "saf${random_id.uniq.hex}"
}
resource "azurerm_network_interface" "Nic" {
name                = "nic"
location            = "${var.Location}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

ip_configuration {
name                          = "configuration1"
subnet_id                     = "${azurerm_subnet.subnet1.id}"
private_ip_address_allocation = "${var.DynamicIP}"
public_ip_address_id = "${azurerm_public_ip.DyanamicIP.id}"
  }
}
resource "azurerm_virtual_machine" "linuxvm" {
  name                  = "${var.vmName}"
  location              = "${var.Location}"
  resource_group_name   = "${azurerm_resource_group.ResourceGroup.name}"
network_interface_ids = ["${azurerm_network_interface.Nic.id}"]
  vm_size               = "${var.vmSize}"
  storage_os_disk {
    name          = "myosdisk1"
    image_uri     = "${var.source_img_uri}"
    vhd_uri       = "https://${var.existing_storage_acct}.blob.core.windows.net/${var.existing_resource_group}-vhds/${var.vmName}${random_id.uniq.hex}osdisk.vhd"
    os_type       = "${var.os_type}"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
 os_profile {
    computer_name  = "${var.vmName}"
    admin_username = "${var.userName}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "staging"
  }
}