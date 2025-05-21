variable "resource_group_name" {
  description = "Name of the resource group. If it doesn't exist, it will be created."
  type        = string
  default     = "learn_databricks_staging"
}

variable "location" {
  description = "The Azure region where the Resource Group and all resources will be created."
  type        = string
  default     = "eastasia"
}

variable "prefix" {
  description = "Prefix for all resource names."
  type        = string
  default     = "ldbs-stg"
}

variable "disable_public_ip" {
  description = "Specifies whether to deploy Azure Databricks workspace with secure cluster connectivity (SCC) enabled or not (No Public IP)."
  type        = bool
  default     = false
}

variable "nsg_name_suffix" {
  description = "Suffix for the network security group name."
  type        = string
  default     = "nsg"
}

variable "pricing_tier" {
  description = "The pricing tier of workspace."
  type        = string
  default     = "premium"
  validation {
    condition     = contains(["trial", "standard", "premium"], var.pricing_tier)
    error_message = "Allowed values for pricing_tier are trial, standard, premium."
  }
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet."
  type        = string
  default     = "10.30.2.0/24"
}

variable "private_subnet_name_suffix" {
  description = "Suffix for the private subnet name."
  type        = string
  default     = "private-snet"
}

variable "public_network_access" {
  description = "Indicates whether public network access is allowed to the workspace with private endpoint - possible values are Enabled or Disabled."
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Allowed values for public_network_access are Enabled or Disabled."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet."
  type        = string
  default     = "10.30.1.0/24"
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR range for the private endpoint subnet."
  type        = string
  default     = "10.30.3.0/27"
}

variable "public_subnet_name_suffix" {
  description = "Suffix for the public subnet name."
  type        = string
  default     = "public-snet"
}

variable "vnet_cidr" {
  description = "CIDR range for the vnet."
  type        = string
  default     = "10.30.0.0/16"
}

variable "vnet_name_suffix" {
  description = "Suffix for the virtual network name."
  type        = string
  default     = "vnet"
}

variable "private_endpoint_subnet_name_suffix" {
  description = "Suffix for the private endpoint subnet name."
  type        = string
  default     = "pe-snet"
}

variable "workspace_name_suffix" {
  description = "Suffix for the Azure Databricks workspace name."
  type        = string
  default     = "databricks-ws"
}

variable "adls_storage_account_name_suffix" {
  description = "Suffix for the ADLS Gen2 storage account name."
  type        = string
  default     = "adlsgen2"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    Environment = "Staging"
    Project     = "Azure Databricks"
  }
}
