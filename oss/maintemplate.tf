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
resource "random_id" "stg" {
  keepers = {
    storageid = "${var.storageAccid}"
  }
  byte_length = 8
}
resource "azurerm_storage_account" "Storage" {
name                = "unmng${random_id.stg.hex}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"
location     = "${var.Location}"
account_type = "${var.storageAccType}"
}
resource "azurerm_storage_container" "container" {
name                  = "stgcontainer11"
resource_group_name   = "${azurerm_resource_group.ResourceGroup.name}"
storage_account_name  = "${azurerm_storage_account.Storage.name}"
container_access_type = "private"
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
resource "azurerm_network_interface" "Nic" {
name                = "nic"
location            = "${var.Location}"
resource_group_name = "${azurerm_resource_group.ResourceGroup.name}"

ip_configuration {
name                          = "configuration1"
subnet_id                     = "${azurerm_subnet.subnet1.id}"
private_ip_address_allocation = "${var.DynamicIP}"
public_ip_address_id = "${azurerm_public_ip.DyanamicIP.ip_address}"
  }
}
resource "azurerm_virtual_machine" "linuxvmStg" {
  name                  = "${var.vmName}"
  location              = "${var.Location}"
  resource_group_name   = "${azurerm_resource_group.ResourceGroup.name}"
   network_interface_ids = ["${azurerm_network_interface.nic1.id}"]
  vm_size               = "${var.vmSize}"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.Storage.primary_blob_endpoint}${azurerm_storage_container.container.name}/osdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk0"
    vhd_uri       = "${azurerm_storage_account.Storage.primary_blob_endpoint}${azurerm_storage_container.container.name}/datadisk0.vhd"
    disk_size_gb  = "1023"
    create_option = "Empty"
    lun           = 0
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