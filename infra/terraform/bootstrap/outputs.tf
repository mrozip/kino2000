output "container_name" {
  description = "Terraform state container name."
  value       = azurerm_storage_container.state.name
}

output "resource_group_name" {
  description = "Terraform state resource group name."
  value       = azurerm_resource_group.state.name
}

output "storage_account_name" {
  description = "Terraform state storage account name."
  value       = azurerm_storage_account.state.name
}
