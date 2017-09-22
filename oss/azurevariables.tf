variable "subscription_id" {
description = "name of the resource group which we created the vnet"
default = "7eab3893-bd71-4690-84a5-47624df0b0e5"
}
variable "client_id" {
description = "where the vnet is create"
default = "d4962dd2-e97e-4f3e-aa00-45e202305782"
}
variable "client_secret" {
description = "CIDR block for virtual network"
default  = "+u9VpFP/ZeqpBKuKoLcAUV8vQmB9xwOhi+RZT7Am/Ys="
}
variable  "tenant_id"  {
description = "CIDR block for subnet1"
default = "dcf9e4d3-f44a-4c28-be12-8245c0d35668"
}
variable "ResourceGroup" {
description = "name of the resource group which we created the vnet"
default = "srikala-terraform"
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
variable "DynamicIP" {
description =  "public_ip_address_allocation dynamic type"
default = "dynamic"
}
variable "DynamicDNS" {
description = "dynamicip domain name label"
default = "dns"
}
variable "storageAccType" {
description = "storage account type"
default = "Standard_LRS"
}
variable "storageAccid" {
description = "storage account name id used for unique string"
default = "storage"
}
variable "vmSize" {
description = "virtual machine size"
default = "Standard_DS1_v2"
}
variable "os_type" {
description = "Type of OS on the existing vhd. Allowed values: 'windows' or 'linux'."
default     = "linux"
}
variable "vmName" {
description = "virtual machine name"
default = "TerraformVM"
}
variable "userName" {
description = "virtual machine admin user name"
default = "adminuser"
}
variable "password" {
description = "virtual machine admin password"
default = "Password@1234"
}
variable "existing_storage_acct" {
description = "The name of the storage account in which your existing VHD and image reside"
default     = "jenkinstestrgdiag334"
}
variable "existing_resource_group" {
description = "The name of the resource group in which your existing storage account with your existing VHD resides"
default     = "jenkinstestrg"
}
variable "source_img_uri" {
description = "Full URIs for one or more custom images (VHDs) that should be copied to the deployment storage account to spin up new VMs from them. URLs must be comma separated."
default = "https://jenkinstestrgdiag334.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.4457b934-e720-4502-af02-74067092ae1a.vhd"
}
