terraform {
    required_providers {
      azurerm={
        source = "hashicorp/azurerm"
        version = "~> 3.0"
      }
    
    }
}
    provider "azurerm" {
      features {}
    }
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "East US"
}
resource "azurerm_resource_group" "rg1" {
  name     = "rg-terraform-1"
  location = "East US"
}