# Changes made to ensure Terraform does NOT try to create the resource group and instead references an existing one:
# Modified Terraform Code for AZURE in eastus

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.57.0"
    }
  }
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group to create and contain the resources."
  type        = string
  default     = "test"

  validation {
    condition     = length(var.resource_group_name) >= 1 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vnet_name" {
  description = "Name of the Azure Virtual Network."
  type        = string
  default     = "test-vnet"

  validation {
    condition     = length(var.vnet_name) >= 2 && length(var.vnet_name) <= 64
    error_message = "Virtual network name must be between 2 and 64 characters."
  }
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

provider "azurerm" {
  {{block_to_replace_cred}}
  features {}
  skip_provider_registration = true
}

# Lookup the already-existing resource group (do not manage/replace it in state)
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "main" {
  address_space       = var.vnet_address_space
  location            = data.azurerm_resource_group.existing.location
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing.name
  tags                = var.tags
}

output "resource_group_name" {
  description = "Name of the created Resource Group."
  value       = data.azurerm_resource_group.existing.name
}

output "virtual_network_id" {
  description = "Resource ID of the created Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "virtual_network_name" {
  description = "Name of the created Virtual Network."
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_address_space" {
  description = "Address space of the created Virtual Network."
  value       = azurerm_virtual_network.main.address_space
}