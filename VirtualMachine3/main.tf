provider "azurerm" {
  features {}
    client_id       = "ae8765b7-3b3e-4a3f-a29a-3e6f520e7bb3"
    client_secret   = "uCf8Q~EWZLnoQK6U1uFGE_Q_2iHgCmw2~7gWfawc"
    tenant_id       = "9eda9bbc-aee0-46cb-840d-03ca38dd86fb"
    subscription_id = "700f82c1-6382-4ce0-8a43-057c81624dd9"
}

resource "azurerm_virtual_network" "example" {
  name                = "vm3-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}
resource "azurerm_availability_set" "example" {
  name                = "example3-avset"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  managed             = true
}
resource "azurerm_subnet" "example" {
  name                 = "mySubnet3"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example3-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = var.vm3_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = var.vm_size

  os_disk {
    name                 = "myOsDisk3"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  computer_name  = "hostname"
  admin_username = "azureadmin"
  admin_password = "password@123"

  disable_password_authentication = false

  availability_set_id = var.availability_zone != null ? azurerm_availability_set.example.id : null
  
}