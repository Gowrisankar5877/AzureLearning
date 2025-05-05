provider "azurerm" {
  features {}
  subscription_id = "xyz-xyz-xyz"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "gowri1RG"
  location = "centralindia"
}

# Virtual Network and Subnets
resource "azurerm_virtual_network" "vnet" {
  name                = "gowri-vnet"
  address_space       = ["10.55.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "gowri-public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.55.1.0/24"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "gowri-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.55.2.0/24"]
}

# Load Balancer and Public IP
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "gowri-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "gowri-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "gowri-frontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "gowri-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "http_probe" {
  name            = "gowri-http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http_rule" {
  name                            = "gowri-http-rule"
  loadbalancer_id                 = azurerm_lb.lb.id
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80
  frontend_ip_configuration_name  = "gowri-frontend"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                        = azurerm_lb_probe.http_probe.id
}

# Network Security Group
resource "azurerm_network_security_group" "web_nsg" {
  name                = "gowri-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                             = "gowri-vmss"
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  sku                              = "Standard_B1s"
  instances                        = 3
  admin_username                   = "xyz"
  admin_password                   = "xyz"  
  disable_password_authentication  = false

  source_image_id = "/subscriptions/<subid>/resourceGroups/gowriRG/providers/Microsoft.Compute/galleries/gowriimages/images/apacheinstallation/versions/1.0.0"
  upgrade_mode                    = "Manual"
  secure_boot_enabled             = true

  network_interface {
    name    = "gowri-nic"
    primary = true

    ip_configuration {
      name                                   = "gowri-ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.private_subnet.id
      load_balancer_backend_address_pool_ids  = [azurerm_lb_backend_address_pool.backend_pool.id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# Output
output "load_balancer_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}
