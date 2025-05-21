variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "prefix" {
  description = "Prefix for all resource names."
  type        = string
}

variable "adls_storage_account_name_suffix" {
  description = "Suffix for the ADLS Gen2 storage account name."
  type        = string
  default     = "adlsgen2"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
