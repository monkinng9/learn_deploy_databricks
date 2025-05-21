terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0" # Pin to a specific minor version for stability
    }
  }
}

provider "azurerm" {
  features {}
}
