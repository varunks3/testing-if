provider "azurerm" {
  features {}
    client_id       = "ae8765b7-3b3e-4a3f-a29a-3e6f520e7bb3"
    client_secret   = "uCf8Q~EWZLnoQK6U1uFGE_Q_2iHgCmw2~7gWfawc"
    tenant_id       = "9eda9bbc-aee0-46cb-840d-03ca38dd86fb"
    subscription_id = "700f82c1-6382-4ce0-8a43-057c81624dd9"
}

data "azurerm_virtual_network" "example-1" {
  name                = var.vnet1_name
  resource_group_name = "Jira-azure"
}

data "azurerm_virtual_network" "example-2" {
  name                = var.vnet2_name
  resource_group_name = "Jira-azure"
}

resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = "Jira-azure"
  virtual_network_name      = data.azurerm_virtual_network.example-1.name
  remote_virtual_network_id = data.azurerm_virtual_network.example-2.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = "Jira-azure"
  virtual_network_name      = data.azurerm_virtual_network.example-2.name
  remote_virtual_network_id = data.azurerm_virtual_network.example-1.id
}