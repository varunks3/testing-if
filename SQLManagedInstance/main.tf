# TODO set the variables below either enter them in plain text after = sign, or change them in variables.tf
#  (var.xyz will take the default value from variables.tf if you don't change it)
provider "azurerm" {
  features {}
    client_id       = "ae8765b7-3b3e-4a3f-a29a-3e6f520e7bb3"
    client_secret   = "uCf8Q~EWZLnoQK6U1uFGE_Q_2iHgCmw2~7gWfawc"
    tenant_id       = "9eda9bbc-aee0-46cb-840d-03ca38dd86fb"
    subscription_id = "700f82c1-6382-4ce0-8a43-057c81624dd9"
}


# Create security group
resource "azurerm_network_security_group" "example" {
  name                = "sql-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "sql-vnet"
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/24"]
  location            = var.location
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "sql-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     =  ["10.0.0.0/24"]

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

# Associate subnet and the security group
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create a route table
resource "azurerm_route_table" "example" {
  name                          = "sql-rt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false
}

# Associate subnet and the route table
resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id
}

# Create managed instance
resource "azurerm_mssql_managed_instance" "main" {
  name                         = "sql-mssql"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  subnet_id                    = azurerm_subnet.example.id
  administrator_login          = "sqluser"
  administrator_login_password = random_password.password.result
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_size_in_gb
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}
