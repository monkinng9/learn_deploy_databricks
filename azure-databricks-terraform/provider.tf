terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Ensure this version is compatible with all resource definitions
    }
  }
}

provider "azurerm" {
  features {}
}
