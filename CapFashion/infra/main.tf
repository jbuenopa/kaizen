# 1. Terraform Settings Block
terraform {
  # 1. Required Version Terraform
  required_version = ">= 0.13"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Terraform Resource to Create Azure Resource Group with Input Variables defined in variables.tf
resource "azurerm_resource_group" "aks_rg" {
  name = var.resource_group_name
  location = var.location
}

# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.aks_rg.location
  include_preview = false
}

# Provision AKS Cluster
/*
1. Add Basic Cluster Settings
  - Get Latest Kubernetes Version from datasource (kubernetes_version)
  - Add Node Resource Group (node_resource_group)
2. Add Default Node Pool Settings
  - orchestrator_version (latest kubernetes version using datasource)
  - availability_zones
  - enable_auto_scaling
  - max_count, min_count
  - os_disk_size_gb
  - type
  - node_labels
  - tags
3. Enable MSI
4. Network Profile
5. Cluster Tags  
6. Public IPs
*/

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "proyecto-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

  default_node_pool {
    name                 = "proyectopool"
    vm_size              = "Standard_B2s"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    enable_node_public_ip = true
    node_labels = {
      "nodepool-type"    = "proyecto"
      "environment"      = "proyecto"
      "nodepoolos"       = "linux"
      "app"              = "proyecto-apps" 
    } 
   tags = {
      "nodepool-type"    = "proyecto"
      "environment"      = "proyecto"
      "nodepoolos"       = "linux"
      "app"              = "proyecto-apps" 
   } 
  }

# Identity (System Assigned or Service Principal)  
  identity {
    type = "SystemAssigned"
  }

# Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }

  tags = {
    Environment = "proyecto"
  }
}
resource "azurerm_kubernetes_cluster_node_pool" "node" {
  name = "proynode"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size = "Standard_B2s"
  node_count = 2
  os_type = "Linux"
  enable_node_public_ip = true
}


#Create public IPs for our Front and Back services
resource "azurerm_public_ip" "public_ip1" {
  name                = "PublicIPBackend"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "public_ip2" {
  name                = "PublicIPFrontend"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}