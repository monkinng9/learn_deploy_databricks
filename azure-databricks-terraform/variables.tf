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

variable "databricks_public_subnet_address_prefix" {
  description = "Address prefix for Databricks public subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "databricks_private_subnet_address_prefix" {
  description = "Address prefix for Databricks private subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "private_endpoints_subnet_address_prefix" {
  description = "Address prefix for the subnet hosting private endpoints."
  type        = list(string)
  default     = ["10.0.3.0/24"]
}