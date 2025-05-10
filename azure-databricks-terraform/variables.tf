variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "learn_databricks"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "eastasia" # Choose a region that supports Premium Databricks & Unity Catalog
}

variable "prefix" {
  description = "A prefix for all resource names to ensure uniqueness."
  type        = string
  default     = "ldb" # learn_databricks
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}