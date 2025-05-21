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

variable "nsg_name_suffix" {
  description = "Suffix for the network security group name."
  type        = string
  default     = "nsg"
}

variable "vnet_name_suffix" {
  description = "Suffix for the virtual network name."
  type        = string
  default     = "vnet"
}

variable "public_subnet_name_suffix" {
  description = "Suffix for the public subnet name."
  type        = string
  default     = "public-snet"
}

variable "private_subnet_name_suffix" {
  description = "Suffix for the private subnet name."
  type        = string
  default     = "private-snet"
}

variable "private_endpoint_subnet_name_suffix" {
  description = "Suffix for the private endpoint subnet name."
  type        = string
  default     = "pe-snet"
}

variable "vnet_cidr" {
  description = "CIDR range for the vnet."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet."
  type        = string
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR range for the private endpoint subnet."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
