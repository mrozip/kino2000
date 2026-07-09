locals {
  name_prefix = "${var.application_name}-${var.environment}"
  tags = merge(
    var.tags,
    {
      application = var.application_name
      environment = var.environment
      managed_by  = "terraform"
    },
  )
}

resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "rg-${local.name_prefix}"
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  location            = azurerm_resource_group.main.location
  name                = "log-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
  tags                = local.tags
}

resource "azurerm_application_insights" "main" {
  application_type    = "web"
  location            = azurerm_resource_group.main.location
  name                = "appi-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
  workspace_id        = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_static_web_app" "web" {
  location            = var.static_web_app_location
  name                = var.static_web_app_name
  resource_group_name = azurerm_resource_group.main.name
  sku_size            = "Free"
  sku_tier            = "Free"
  tags                = local.tags
}

resource "azurerm_storage_account" "functions" {
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  location                        = azurerm_resource_group.main.location
  min_tls_version                 = "TLS1_2"
  name                            = var.function_storage_account_name
  resource_group_name             = azurerm_resource_group.main.name
  tags                            = local.tags
}

resource "azurerm_storage_account_static_website" "web_fallback" {
  error_404_document = "index.html"
  index_document     = "index.html"
  storage_account_id = azurerm_storage_account.functions.id
}

resource "azurerm_service_plan" "api" {
  count = var.provision_api ? 1 : 0

  location            = azurerm_resource_group.main.location
  name                = "asp-${local.name_prefix}"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Y1"
  tags                = local.tags
}

resource "azurerm_linux_function_app" "api" {
  count = var.provision_api ? 1 : 0

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
    FUNCTIONS_WORKER_RUNTIME              = "node"
    WEBSITE_RUN_FROM_PACKAGE              = "1"
  }

  functions_extension_version = "~4"
  https_only                  = true
  location                    = azurerm_resource_group.main.location
  name                        = var.function_app_name
  resource_group_name         = azurerm_resource_group.main.name
  service_plan_id             = azurerm_service_plan.api[0].id
  storage_account_access_key  = azurerm_storage_account.functions.primary_access_key
  storage_account_name        = azurerm_storage_account.functions.name
  tags                        = local.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_insights_connection_string = azurerm_application_insights.main.connection_string

    application_stack {
      node_version = "20"
    }
  }
}

resource "azurerm_cosmosdb_account" "main" {
  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    failover_priority = 0
    location          = azurerm_resource_group.main.location
  }

  kind                = "GlobalDocumentDB"
  location            = azurerm_resource_group.main.location
  name                = "cosmos-${local.name_prefix}"
  offer_type          = "Standard"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_cosmosdb_sql_database" "main" {
  account_name        = azurerm_cosmosdb_account.main.name
  name                = var.cosmos_database
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_cosmosdb_sql_container" "movies" {
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  name                = "movies"
  partition_key_paths = ["/id"]
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_cosmosdb_sql_container" "users" {
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  name                = "users"
  partition_key_paths = ["/id"]
  resource_group_name = azurerm_resource_group.main.name
}
