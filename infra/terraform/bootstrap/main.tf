resource "azurerm_resource_group" "state" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

resource "azurerm_storage_account" "state" {
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  location                        = azurerm_resource_group.state.location
  min_tls_version                 = "TLS1_2"
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.state.name
  tags                            = var.tags
}

resource "azurerm_storage_container" "state" {
  container_access_type = "private"
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.state.id
}
