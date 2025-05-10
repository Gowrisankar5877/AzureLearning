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
 
module "child_module" {
  source = "./child_module"

  vm_count = 1
 environment = "production"
  location    = "EastUS"
 ci1="10.0.4.0"
}
output "azurerm_public_ip"{
  value = module.child_module.myoutput
}