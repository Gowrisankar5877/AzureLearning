terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = "gowritfstate"
  location = "East US"
}

resource "azurerm_resource_group" "tfstate3" {
  name     = "gowrisampletfstate1"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "gowritfstate4q9gh"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "gowritfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}