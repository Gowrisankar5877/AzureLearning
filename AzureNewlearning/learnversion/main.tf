# provider "azurerm" {
#   version = "=2.40.0"
#   features {}
# }

# valid for terraform version >= 0.14
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
	      version = "~> 2.0"
    }
  }
	required_version = ">=1.0"
}

data  "azurerm_resource_group" "rg" {
  name     = "gowriRG"

}

output "id" {
	value = data.azurerm_resource_group.rg.id
}

resource "azurerm_virtual_network" "example" {
  name                = "gowri-network"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}
