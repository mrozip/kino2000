output "api_default_hostname" {
  description = "Default hostname for the Azure Functions API."
  value       = var.provision_api ? azurerm_linux_function_app.api[0].default_hostname : ""
}

output "function_app_name" {
  description = "Azure Functions app name."
  value       = var.provision_api ? azurerm_linux_function_app.api[0].name : ""
}

output "resource_group_name" {
  description = "Development resource group name."
  value       = azurerm_resource_group.main.name
}

output "static_web_app_default_host_name" {
  description = "Default hostname for the Static Web App."
  value       = azurerm_static_web_app.web.default_host_name
}

output "static_web_app_name" {
  description = "Azure Static Web App name."
  value       = azurerm_static_web_app.web.name
}

output "storage_static_website_url" {
  description = "Fallback static website endpoint served from the development storage account."
  value       = azurerm_storage_account.functions.primary_web_endpoint
}
