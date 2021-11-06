terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure Provider

provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "vmss" {
  name     = "${var.client}_resource_group"
  location = var.location
  tags = var.tags
}

resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vmss" {
  name                = "${var.client}_vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  tags = var.tags
}

# Create a Subnet
resource "azurerm_subnet" "vmss" {
  name                 = "${var.client}_vmss-subnet"
  resource_group_name  = azurerm_resource_group.vmss.name
  virtual_network_name = azurerm_virtual_network.vmss.name
  address_prefixes       = ["10.0.2.0/24"]
}

# Create a security group

resource "azurerm_network_security_group" "vmss" {
  name                = "${var.client}_acceptanceTestSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  tags = var.tags

    security_rule {
      name                       = "test123"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
}

# Create a Load balancer
resource "azurerm_public_ip" "vmss" {
  name                         = "${var.client}_vmss-public-ip"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.vmss.name
  allocation_method            = "Static"
  domain_name_label            = random_string.fqdn.result
  tags = var.tags
}

resource "azurerm_lb" "vmss" {
  name                = "${var.client}_vmss-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name

  frontend_ip_configuration {
    name                 = "${var.client}_PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id     = azurerm_lb.vmss.id
  name                = "${var.client}_BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = azurerm_resource_group.vmss.name
  loadbalancer_id     = azurerm_lb.vmss.id
  name                = "${var.client}_ssh-running-probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = azurerm_resource_group.vmss.name
  loadbalancer_id                = azurerm_lb.vmss.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration_name = "${var.client}_PublicIPAddress"
  probe_id                       = azurerm_lb_probe.vmss.id
}

# Create availability set

resource "azurerm_availability_set" "vmss" {
  name                = "${var.client}-aset"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  tags = var.tags
}


# Create VMSS
data "azurerm_resource_group" "image" {
  name = var.packer_resource_group_name
}

data "azurerm_image" "image" {
  name                = var.packer_image_name
  resource_group_name = data.azurerm_resource_group.image.name
}



resource "azurerm_public_ip" "jumpbox" {
  name                         = "${var.client}_jumpbox-public-ip${count.index}"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.vmss.name
  allocation_method            = "Static"
  domain_name_label            = "${random_string.fqdn.result}-ssh-${count.index}"
  tags = var.tags
  count = var.vm_count
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "${var.client}_jumpbox-nic-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vmss.name
  count = var.vm_count

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = azurerm_subnet.vmss.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.jumpbox.*.id,count.index)
  }

  tags = var.tags
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "${var.client}-jumpbox-jumpbox${count.index}"
  count                 = var.vm_count
  location              = var.location
  resource_group_name   = azurerm_resource_group.vmss.name
  availability_set_id   = azurerm_availability_set.vmss.id
  network_interface_ids = [element(azurerm_network_interface.jumpbox.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"
  storage_image_reference {
    id = data.azurerm_image.image.id
  }

  storage_os_disk {
    name              = "jumpbox-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.client}-jumpbox-${count.index}"
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  tags = var.tags
}