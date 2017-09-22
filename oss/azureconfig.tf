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
variable "Subnet2" {
description = "CIDR block for subnet2"
}
variable "Subnet3" {
description = "CIDR block for subnet3"
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