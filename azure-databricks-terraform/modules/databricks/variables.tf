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

variable "workspace_name_suffix" {
  description = "Suffix for the Azure Databricks workspace name."
  type        = string
  default     = "databricks-ws"
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

variable "public_network_access" {
  description = "Indicates whether public network access is allowed to the workspace with private endpoint - possible values are Enabled or Disabled."
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Allowed values for public_network_access are Enabled or Disabled."
  }
}

variable "disable_public_ip" {
  description = "Specifies whether to deploy Azure Databricks workspace with secure cluster connectivity (SCC) enabled or not (No Public IP)."
  type        = bool
  default     = false
}

variable "virtual_network_id" {
  description = "ID of the virtual network."
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet."
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet."
  type        = string
}

variable "public_subnet_nsg_association_id" {
  description = "ID of the public subnet NSG association."
  type        = string
}

variable "private_subnet_nsg_association_id" {
  description = "ID of the private subnet NSG association."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet."
  type        = string
}

variable "create_private_endpoint" {
  description = "Whether to create a private endpoint for the Databricks workspace."
  type        = bool
  default     = true
}

variable "vnet_name" {
  description = "Name of the virtual network for DNS link naming."
  type        = string
}

variable "dependencies" {
  description = "List of resources that the Databricks workspace depends on."
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
