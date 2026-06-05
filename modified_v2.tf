# Creates an Azure Resource Group (grait-rg) and an Azure Virtual Network (test-vnet) in eastus with address space 10.0.0.0/16 using the azurerm provider.
# Generated Terraform code for AZURE in eastus

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.57.0"
    }
  }
}

variable "address_space" {
  description = "Address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "location" {
  description = "Azure region for the Resource Group and Virtual Network."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Resource Group to create/use for the Virtual Network."
  type        = string
  default     = "grait-rg"
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
  default     = "test-vnet"
}

provider "azurerm" {
  {{block_to_replace_cred}}
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "main" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

resource "azurerm_virtual_network" "main" {
  address_space       = var.address_space
  location            = azurerm_resource_group.main.location
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

output "resource_group_name" {
  description = "Name of the Resource Group containing the Virtual Network."
  value       = azurerm_resource_group.main.name
}

output "virtual_network_id" {
  description = "Resource ID of the Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "virtual_network_name" {
  description = "Name of the Virtual Network."
  value       = azurerm_virtual_network.main.name
}