# Azure Databricks Terraform Infrastructure

This repository contains Terraform code for deploying Azure Databricks workspaces and related infrastructure in a modular, environment-specific approach.

## Project Structure

```
.
├── environments/
│   ├── dev/
│   │   ├── main.tf           # Main configuration for development environment
│   │   ├── outputs.tf        # Outputs for development environment
│   │   ├── variables.tf      # Variables for development environment
│   │   ├── providers.tf      # Provider configuration for development environment
│   │   └── terraform.tfvars  # Variable values for development environment
│   ├── staging/
│   │   ├── main.tf           # Main configuration for staging environment
│   │   ├── outputs.tf        # Outputs for staging environment
│   │   ├── variables.tf      # Variables for staging environment
│   │   ├── providers.tf      # Provider configuration for staging environment
│   │   └── terraform.tfvars  # Variable values for staging environment
│   └── prod/
│       ├── main.tf           # Main configuration for production environment
│       ├── outputs.tf        # Outputs for production environment
│       ├── variables.tf      # Variables for production environment
│       ├── providers.tf      # Provider configuration for production environment
│       └── terraform.tfvars  # Variable values for production environment
├── modules/
│   ├── vnet/
│   │   ├── main.tf           # Virtual network, subnets, and NSG configuration
│   │   ├── variables.tf      # Input variables for the vnet module
│   │   └── outputs.tf        # Output values from the vnet module
│   ├── databricks/
│   │   ├── main.tf           # Databricks workspace and private endpoint configuration
│   │   ├── variables.tf      # Input variables for the databricks module
│   │   └── outputs.tf        # Output values from the databricks module
│   └── storage/
│       ├── main.tf           # ADLS Gen2 storage account configuration
│       ├── variables.tf      # Input variables for the storage module
│       └── outputs.tf        # Output values from the storage module
└── .gitignore
```

## Modules

### VNet Module

The VNet module creates:
- Virtual Network
- Network Security Group with rules for Databricks
- Public and Private subnets for Databricks
- Private Endpoint subnet

### Databricks Module

The Databricks module creates:
- Azure Databricks Workspace
- Private Endpoint (optional)
- Private DNS Zone for Databricks

### Storage Module

The Storage module creates:
- ADLS Gen2 Storage Account with hierarchical namespace enabled

## Environments

### Development (dev)

Development environment with:
- Public network access enabled
- Public IPs allowed for clusters

### Staging (staging)

Staging environment with:
- Public network access enabled
- Public IPs allowed for clusters

### Production (prod)

Production environment with:
- Public network access disabled
- No public IPs for clusters (Secure Cluster Connectivity)

## Usage

To deploy an environment:

1. Navigate to the desired environment directory:
   ```
   cd environments/dev
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Plan the deployment:
   ```
   terraform plan
   ```

4. Apply the changes:
   ```
   terraform apply
   ```

## Notes

- Each environment has its own state file
- Environment-specific configurations are in the respective terraform.tfvars files
- Sensitive information should be stored in environment variables or Azure Key Vault
