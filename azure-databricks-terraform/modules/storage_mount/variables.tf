# variables.tf for storage_mount module

variable "resource_group_name" {
  description = "Name of the Azure Resource Group where the storage account resides."
  type        = string
}

variable "storage_account_name" {
  description = "Name of the existing Azure Storage Account (used for Databricks mount config)."
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the existing Azure Storage Account where the container will be created."
  type        = string
}

variable "storage_container_name" {
  description = "Name for the new Azure Storage Container. This will also be used as the ABFSS filesystem name."
  type        = string
}

variable "databricks_mount_name" {
  description = "Name for the mount point in Databricks DBFS (e.g., \"mydata\" will be mounted at /mnt/mydata)."
  type        = string
}

variable "databricks_cluster_id" {
  description = "ID of an active Databricks cluster to execute the mount command on. The cluster must be running when applying this configuration."
  type        = string
}

variable "databricks_secret_scope" {
  description = "Name of the Databricks secret scope that stores the Azure Storage Account access key."
  type        = string
}

variable "databricks_secret_key_name" {
  description = "Name of the secret key within the specified scope that holds the Azure Storage Account access key."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the Azure Storage Container."
  type        = map(string)
  default     = {}
}
