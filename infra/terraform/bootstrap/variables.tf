variable "container_name" {
  description = "Name of the Azure Storage container used for Terraform state."
  type        = string
}

variable "location" {
  description = "Azure region for the remote-state resource group."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group that stores Terraform state."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique storage account name for Terraform state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must be 3-24 lowercase letters or numbers."
  }
}

variable "subscription_id" {
  default     = null
  description = "Azure subscription ID. Defaults to ARM_SUBSCRIPTION_ID when omitted."
  nullable    = true
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags applied to bootstrap resources."
  type        = map(string)
}
