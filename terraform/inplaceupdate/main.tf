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
}

# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = "gowri-rg-tf"
  location = "East US"
}

# Define the virtual network
resource "azurerm_virtual_network" "example" {
  name                = "gowri-vnet-tf"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

# Define the subnet
resource "azurerm_subnet" "example" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define the Network Interface Cards (NICs)
resource "azurerm_network_interface" "example" {
  name                = "gowri-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "backend"
  }
}

resource "azurerm_network_interface" "example2" {
  name                = "gowri-nic-2"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "backend1"
    name = "gowrisankar1"
  }
}

# Define VM2
resource "azurerm_linux_virtual_machine" "example2" {
  name                = "gowri-tf-vm3"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "gowri"

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  admin_ssh_key {
    username   = "gowri"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.example2.id]

  tags = {
    environment = "frontend2"
    name = "gowrisankar"
  }

  lifecycle {
    ignore_changes = [os_disk] # allow disk changes without recreation
    #prevent_destroy = false
    create_before_destroy = true
  }
}

# Define VM1 that depends on VM2
resource "azurerm_linux_virtual_machine" "example1" {
  name                = "gowri-tf-vm4"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "gowri"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  admin_ssh_key {
    username   = "gowri"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.example.id]

  tags = {
    environment = "backend1"
  }

  depends_on = [
    azurerm_linux_virtual_machine.example2
  ]

  lifecycle {
    ignore_changes = [os_disk] # allow disk changes without recreation
    #prevent_destroy = true
    create_before_destroy = true
  }
}
