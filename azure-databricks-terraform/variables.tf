variable "resource_group_name" {
  description = "Name of the resource group. If it doesn't exist, it will be created."
  type        = string
  default     = "learn_databricks" # As requested
}

variable "location" {
  description = "The Azure region where the Resource Group and all resources will be created."
  type        = string
  default     = "eastasia" # Default location if not specified
}

variable "prefix" {
  description = "Prefix for all resource names."
  type        = string
  default     = "ldbs" # As requested
}

variable "disable_public_ip" {
  description = "Specifies whether to deploy Azure Databricks workspace with secure cluster connectivity (SCC) enabled or not (No Public IP)."
  type        = bool
  default     = true
}

variable "nsg_name_suffix" {
  description = "Suffix for the network security group name."
  type        = string
  default = "nsg"
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
  default     = "10.20.2.0/24" # Example, adjust as needed
}

variable "private_subnet_name_suffix" {
  description = "Suffix for the private subnet name."
  type        = string
  default     = "private-snet"
}

variable "public_network_access" {
  description = "Indicates whether public network access is allowed to the workspace with private endpoint - possible values are Enabled or Disabled."
  type        = string
  default     = "Disabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Allowed values for public_network_access are Enabled or Disabled."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet."
  type        = string
  default     = "10.20.1.0/24" # Example, adjust as needed
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR range for the private endpoint subnet."
  type        = string
  default     = "10.20.3.0/27" # Example, adjust as needed, /27 or larger often recommended
}

variable "public_subnet_name_suffix" {
  description = "Suffix for the public subnet name."
  type        = string
  default     = "public-snet"
}

variable "required_nsg_rules" {
  description = "Indicates whether to retain or remove the AzureDatabricks outbound NSG rule - possible values are AllRules or NoAzureDatabricksRules."
  type        = string
  default     = "NoAzureDatabricksRules" # We define rules in main.tf
  validation {
    condition     = contains(["AllRules", "NoAzureDatabricksRules"], var.required_nsg_rules)
    error_message = "Allowed values for required_nsg_rules are AllRules or NoAzureDatabricksRules."
  }
}

variable "vnet_cidr" {
  description = "CIDR range for the vnet."
  type        = string
  default     = "10.20.0.0/16" # Example, adjust as needed
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
  default     = "adlsgen2" # Example suffix, ensure it helps create a globally unique name
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
