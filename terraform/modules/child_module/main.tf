
 
resource "azurerm_resource_group" "example" {
  name     = "gowri-demo${terraform.workspace}"
  location = var.location
}
 
resource "azurerm_virtual_network" "example" {
  name                = "gowri-network"
  address_space       = ["${var.ci1}/24"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
 
resource "azurerm_subnet" "example" {
  name                 = "gowri-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["${var.ci1}/24"]
}
 
resource "azurerm_public_ip" "public_ip" {
  name                = "gowri-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method = "Static"
}
 
resource "azurerm_network_interface" "example" {
  name                = "gowri-nic${terraform.workspace}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
 
  ip_configuration {
    name                          = "internal${terraform.workspace}"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
 
resource "azurerm_linux_virtual_machine" "example" {
  count = var.vm_count
  name                = "gowri-machine${count.index}${var.environment}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "User12"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
 
  admin_ssh_key {
    username   = "User12"
    public_key = file("/home/user12/.ssh/id_rsa.pub")
  }
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
 
  tags = {
    Name = "dev"
  }
}

output "myoutput"{
  value = azurerm_public_ip.public_ip.id
  
}