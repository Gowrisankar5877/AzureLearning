terraform {
    backend "azurerm" {
      resource_group_name  = "gowritfstate"
      storage_account_name = "gowritfstatel2kph"
      container_name       = "gowritfstate"
      key                  = "terraform.tfstate"
  }
 
}
 
resource "azurerm_resource_group" "state-demo-secure" {
  name     = "gowristate-demo"
  location = "eastus"
}
 