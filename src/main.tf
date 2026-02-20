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

resource "azurerm_storage_account" "sa" {
    name                     = "${var.stgname}${random_string.rndsa.result}"
    resource_group_name      = module.rg.name
    location                 = module.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    depends_on = [ module.rg ]
}
locals {
  vnet_name             = ["vnet1", "vnet2", "vnet3"]
  vnet_address_prefixes = ["10.200.0.0/16", "10.201.0.0/16", "10.202.0.0/16"]
  vnets                 = zipmap(var.vnet_names, var.vnet_address_prefixes)
}
resource "azurerm_virtual_network" "vnets" {
  for_each = local.vnets

  name                = each.key
  address_space       = [each.value]
  location            = module.rg.location
  resource_group_name = module.rg.name
  depends_on          = [module.rg]
}