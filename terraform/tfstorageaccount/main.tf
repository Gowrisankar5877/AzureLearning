provider "azurerm" {
  # Configuration options
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
data "azurerm_resource_group" "example" {
  name     = "gowriRG"
}
 
resource "azurerm_storage_account" "example" {
  name                     = "gowristoraccounttest"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
 
resource "azurerm_storage_container" "example" {
  name                  = "gowrisatestcontainer"
  storage_account_name    = azurerm_storage_account.example.name
  container_access_type = "private"
}
