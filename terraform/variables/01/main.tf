provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}

resource "azurerm_resource_group" "example" {
  #name     = var.example_var
  name     = "myRG${var.example_var}"
  location = "eastus"
}

output "example_var"{
  value=azurerm_resource_group.example.name
}