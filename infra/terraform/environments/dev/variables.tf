variable "application_name" {
  description = "Short application name used in Azure resource names and tags."
  type        = string
}

variable "cosmos_database" {
  description = "Cosmos DB SQL database name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "function_app_name" {
  description = "Globally unique Azure Functions app name."
  type        = string
}

variable "function_storage_account_name" {
  description = "Globally unique storage account name for the Azure Functions app."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.function_storage_account_name))
    error_message = "The storage account name must be 3-24 lowercase letters or numbers."
  }
}

variable "location" {
  description = "Azure region for the development resource group."
  type        = string
}

variable "provision_api" {
  default     = true
  description = "Whether to provision the Azure Functions hosting resources. Disable when the subscription lacks App Service quota."
  type        = bool
}

variable "static_web_app_location" {
  description = "Azure region for the Static Web App."
  type        = string
}

variable "static_web_app_name" {
  description = "Globally unique Azure Static Web App name."
  type        = string
}

variable "subscription_id" {
  default     = null
  description = "Azure subscription ID. Defaults to ARM_SUBSCRIPTION_ID when omitted."
  nullable    = true
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags applied to development resources."
  type        = map(string)
}
