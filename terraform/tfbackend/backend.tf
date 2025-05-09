terraform {
  

  
  backend "azurerm" {
      resource_group_name  = "gowritfstate"
      storage_account_name = "gowritfstate4q9gh"
      container_name       = "gowritfstate"
      key                  = "terraform.tfstate"
  }

}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "gowristate-demo"
  location = "eastus"
}