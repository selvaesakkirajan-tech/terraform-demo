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

resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}-${random_string.rnd.result}"
   location = var.location
}