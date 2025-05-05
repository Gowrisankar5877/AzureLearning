provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias    = "secondary"
  features {}
}

resource "azurerm_resource_group" "example1" {
  name     = "gowrirsg1"
  location = "eastus"
}

resource "azurerm_resource_group" "example2" {
  name     = "gowrirsg2"
  location = "westus"
  provider = azurerm.secondary
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}
