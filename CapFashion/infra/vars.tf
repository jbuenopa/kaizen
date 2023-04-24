# Azure Location
variable "location" {
  type = string
  description = "Azure Region where all these resources will be provisioned"
  default = "West Europe"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "This variable defines the Resource Group"
  default = "Proyecto-Kaizen-2023"
}

# Azure AKS Environment Name
variable "environment" {
  type = string  
  description = "This variable defines the Environment"  
  default = "proyecto"
}

variable "node_resource_group_name" {
  type = string
  description = "This variable defines the Node Resource Group"
  default = "${azurerm_resource_group.aks_rg.name}-nrg"
}

# # AKS Input Variables

# # SSH Public Key for Linux VMs
# variable "ssh_public_key" {
#   default = "~/.ssh/aks-prod-sshkeys-terraform/aksprodsshkey.pub"
#   description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
# }