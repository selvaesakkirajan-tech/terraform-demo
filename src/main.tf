terraform {
    required_providers {
      azurerm={
        source = "hashicorp/azurerm"
        version = "~> 3.0"
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
    resource "random_string" "rnd" {
        length  = 4
        special = false
        upper   = false
        numeric = false

    }
      resource "random_string" "rndsa" {
        length  = 4
        special = false
        upper   = false
    }
resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}-${random_string.rnd.result}"
   location = var.location
}
resource "azurerm_storage_account" "sa" {
    name                     = "${var.stgname}${random_string.rndsa.result}"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    depends_on = [ azurerm_resource_group.rg ]
}