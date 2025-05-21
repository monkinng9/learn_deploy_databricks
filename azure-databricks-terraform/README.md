# Azure Databricks Terraform

## 1\. Project Overview 🌟

  - **Project Goal:** To define and provision Azure Databricks environments (dev, staging, prod) along with associated networking (VNet, subnets, NSG) and storage (ADLS Gen2) resources using Terraform for Infrastructure as Code.
  - **Core AI/LLM Task(s):** Not Applicable. This project is for cloud infrastructure provisioning.
  - **Primary Technologies/Frameworks Used:** Terraform, Azure Resource Manager (ARM), HCL (HashiCorp Configuration Language).
  - **Version Control System:** Not explicitly stated, but the project structure (e.g., `.terraform` directories) strongly suggests a Git-based system. Repository URL is not provided.
  - **Current Version/Release:**
      * Terraform CLI (used for `dev` environment state): `1.11.4`
      * AzureRM Provider (`azurerm`): `~> 3.90.0` (as specified in `provider.tf` and `environments/*/providers.tf`)
  - **Contact Point/Lead Developer (Optional):** Not Applicable.

## 2\. High-Level Architecture 🏗️

  - **System Diagram:**
    Textual description: The project utilizes Terraform to manage Azure infrastructure, offering two main approaches for deployment:

    1.  **Root Configuration (`project-root/*.tf` files):** This setup provisions resources *within an existing Azure Resource Group*. It directly defines networking (VNet, subnets, NSG), an Azure Databricks workspace with Private Link, and an Azure Data Lake Storage Gen2 account. The resource group name is provided as input, and its location is used for all deployed resources.
    2.  **Environment-Specific Configurations (`environments/{dev,prod,staging}/`):** Each environment directory contains a full Terraform setup that *creates its own Azure Resource Group* and then deploys resources within it. These configurations leverage reusable modules (`../../modules/*`) to provision:
          * A Virtual Network (`modules/vnet`).
          * An Azure Databricks workspace with Private Link (`modules/databricks`).
          * An Azure Data Lake Storage Gen2 account (`modules/storage`).
            Environment-specific parameters are supplied via `terraform.tfvars` files.

  - **Key Components & Their Responsibilities:**

      - **Root Terraform Configuration (`project-root/*.tf`):**
          - `main.tf`: Defines Azure resources such as `azurerm_network_security_group`, `azurerm_virtual_network`, `azurerm_subnet`, `azurerm_databricks_workspace`, `azurerm_private_endpoint`, `azurerm_private_dns_zone`, and `azurerm_storage_account`. It uses a `data "azurerm_resource_group"` to reference an existing resource group.
          - `variables.tf`: Declares input variables for the root configuration, like `resource_group_name`.
          - `outputs.tf`: Defines outputs for the resources created by the root configuration.
      - **Environment Configurations (e.g., `environments/dev/`):**
          - `main.tf`: Defines an `azurerm_resource_group` and then calls reusable modules (`../../modules/vnet`, `../../modules/databricks`, `../../modules/storage`) to deploy infrastructure within this new resource group.
          - `variables.tf`: Declares input variables for the specific environment (e.g., `resource_group_name`, `prefix`, CIDR ranges).
          - `terraform.tfvars`: Provides values for the variables declared in `variables.tf` for that environment.
          - `outputs.tf`: Declares outputs from the module instantiations for that environment.
      - **`modules/vnet/`:**
          - `main.tf`: Creates `azurerm_network_security_group`, `azurerm_virtual_network`, `azurerm_subnet` (public, private, private\_endpoint), and `azurerm_subnet_network_security_group_association`.
      - **`modules/databricks/`:**
          - `main.tf`: Creates `azurerm_databricks_workspace`, and conditionally `azurerm_private_endpoint`, `azurerm_private_dns_zone`, `azurerm_private_dns_zone_virtual_network_link`.
      - **`modules/storage/`:**
          - `main.tf`: Creates `azurerm_storage_account` for ADLS Gen2.

  - **Data Flow:**
    *When using environment-specific configuration (e.g., `environments/dev/`):*

    1.  User navigates to the environment directory (e.g., `cd environments/dev`).
    2.  Terraform reads the `main.tf`, which defines a resource group and calls modules (`vnet`, `databricks`, `storage`).
    3.  Variable values are sourced from `terraform.tfvars` and environment variables.
    4.  Modules receive inputs and define their respective Azure resources.
    5.  Terraform builds a plan and, upon apply, makes API calls to Azure to create/update the resource group and all resources within it.
    6.  State is saved to `environments/dev/terraform.tfstate`.
        *When using root configuration (`project-root/`):*
    7.  User navigates to the project root.
    8.  Terraform reads `main.tf`, which defines resources directly. An existing resource group name is expected as input (`var.resource_group_name`).
    9.  Variable values are sourced from `vars.tfvars` and environment variables.
    10. Terraform builds a plan and, upon apply, makes API calls to Azure to create/update resources within the specified existing resource group.
    11. State is saved to `project-root/terraform.tfstate`.

## 3\. Directory Structure 📂

```
project-root/
├── .terraform/                 # Purpose: Contains downloaded providers and modules for the root configuration.
├── environments/               # Purpose: Contains environment-specific configurations (dev, prod, staging).
│   ├── dev/                    # Purpose: Configuration for the Development environment.
│   │   ├── .terraform/         # Purpose: Contains downloaded providers and cached modules for the 'dev' environment.
│   │   ├── main.tf             # Purpose: Main configuration for 'dev' environment; creates RG & calls modules.
│   │   ├── outputs.tf          # Purpose: Defines output values for the 'dev' environment.
│   │   ├── providers.tf        # Purpose: Defines provider configurations for the 'dev' environment.
│   │   ├── terraform.tfstate   # Purpose: Stores the state of 'dev' environment's managed infrastructure.
│   │   ├── terraform.tfvars    # Purpose: Contains variable values specific to the 'dev' environment.
│   │   └── variables.tf        # Purpose: Declares variables for the 'dev' environment.
│   ├── prod/                   # Purpose: Configuration for the Production environment.
│   │   ├── main.tf             # Purpose: Main configuration for 'prod' environment; creates RG & calls modules.
│   │   ├── outputs.tf          # Purpose: Defines output values for the 'prod' environment.
│   │   ├── providers.tf        # Purpose: Defines provider configurations for the 'prod' environment.
│   │   ├── terraform.tfvars    # Purpose: Contains variable values specific to the 'prod' environment.
│   │   └── variables.tf        # Purpose: Declares variables for the 'prod' environment.
│   └── staging/                # Purpose: Configuration for the Staging environment.
│       ├── main.tf             # Purpose: Main configuration for 'staging' environment; creates RG & calls modules.
│       ├── outputs.tf          # Purpose: Defines output values for the 'staging' environment.
│       ├── providers.tf        # Purpose: Defines provider configurations for the 'staging' environment.
│       ├── terraform.tfvars    # Purpose: Contains variable values specific to the 'staging' environment.
│       └── variables.tf        # Purpose: Declares variables for the 'staging' environment.
├── modules/                    # Purpose: Contains reusable Terraform modules for creating specific resources.
│   ├── databricks/             # Purpose: Module for Azure Databricks workspace and related resources (Private Link).
│   │   ├── main.tf             # Purpose: Main logic for the Databricks module.
│   │   ├── outputs.tf          # Purpose: Outputs for the Databricks module.
│   │   └── variables.tf        # Purpose: Input variables for the Databricks module.
│   ├── storage/                # Purpose: Module for Azure ADLS Gen2 storage.
│   │   ├── main.tf             # Purpose: Main logic for the Storage module.
│   │   ├── outputs.tf          # Purpose: Outputs for the Storage module.
│   │   └── variables.tf        # Purpose: Input variables for the Storage module.
│   └── vnet/                   # Purpose: Module for Azure Virtual Network, subnets, and NSG.
│       ├── main.tf             # Purpose: Main logic for the VNet module.
│       ├── outputs.tf          # Purpose: Outputs for the VNet module.
│       └── variables.tf        # Purpose: Input variables for the VNet module.
├── main.tf                     # Purpose: Root main configuration file; defines infrastructure within an existing RG.
├── outputs.tf                  # Purpose: Root outputs definitions for the root configuration.
├── provider.tf                 # Purpose: Root provider configuration (AzureRM).
├── terraform.tfstate           # Purpose: Root Terraform state file (for the root configuration).
├── terraform.tfstate.backup    # Purpose: Backup of the root Terraform state file.
├── variables.tf                # Purpose: Root variable declarations for the root configuration.
└── vars.tfvars                 # Purpose: Root variable values for the root configuration.
```

  - **Key Files/Modules & Their Purpose:**
      - `main.tf` (root): Defines a complete Azure infrastructure setup (VNet, Databricks, Storage, etc.) to be provisioned within an *existing* resource group.
      - `environments/<env>/main.tf` (e.g., `environments/dev/main.tf`): Entry point for deploying a specific environment; creates a new resource group and then calls `vnet`, `databricks`, and `storage` modules.
      - `modules/databricks/main.tf`: Defines the `azurerm_databricks_workspace` resource, and optionally its private endpoint, private DNS zone, and DNS link.
      - `modules/vnet/main.tf`: Defines Azure VNet, subnets (public, private, private\_endpoint), and Network Security Group (NSG).
      - `modules/storage/main.tf`: Defines Azure ADLS Gen2 storage account.

## 4\. Core LLM Components & Logic 🧠

  - Not Applicable. This project is for infrastructure provisioning using Terraform and does not involve LLM components.

## 5\. Data Handling & Preprocessing 📊

  - Not Applicable. This project deals with infrastructure definitions. Data for Terraform is primarily in the form of variable values in `.tfvars` files and variable definitions in `.tf` files.

## 6\. Setup & Dependencies ⚙️

  - **Programming Language(s) & Version(s):**
      - HCL (HashiCorp Configuration Language) for Terraform definitions.
      - Terraform CLI version `1.11.4` (as indicated by the `dev` environment's state file) or a compatible version.
  - **Key Dependencies:**
      - Terraform CLI.
      - `azurerm` (Azure Resource Manager) Terraform provider, version `~> 3.90.0`.
  - **Environment Setup Instructions:**
    1.  Install the Terraform CLI.
    2.  Clone the repository.
    3.  Configure Azure credentials for Terraform. This typically involves logging in via Azure CLI (`az login`) or setting environment variables for a Service Principal (e.g., `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`).
    4.  Navigate to the desired configuration directory:
          * For an environment-specific deployment: `cd environments/<env_name>` (e.g., `cd environments/dev`).
          * For the root configuration deployment: `cd project-root`.
    5.  Initialize Terraform: `terraform init`. This command downloads necessary providers and modules.
    6.  (Optional) Review and modify `terraform.tfvars` (for environments) or `vars.tfvars` (for root) to set desired variable values.
  - **Hardware Requirements (if specific):** Standard computer capable of running the Terraform CLI and connecting to Azure APIs. No special high-performance hardware is required for Terraform execution.

## 7\. How to Run & Test the Code 🚀

  - **Main Execution Points/Entry Scripts:**
      * **For deploying/managing an environment (e.g., 'dev'):**
        ```bash
        cd environments/dev
        terraform init
        terraform validate
        terraform plan -out=plan.tfplan
        terraform apply "plan.tfplan"
        ```
      * **For deploying/managing infrastructure using the root configuration:**
        ```bash
        # Ensure project-root/vars.tfvars is configured or use -var-file option
        # Ensure the resource group specified in vars.tfvars already exists
        terraform init
        terraform validate
        terraform plan -out=plan.tfplan
        terraform apply "plan.tfplan"
        ```
      * **To see outputs after deployment (e.g., in 'dev' environment):**
        ```bash
        cd environments/dev
        terraform output
        # Or specific output: terraform output databricks_workspace_url
        ```
  - **Running Tests:**
      - Syntax and configuration validation: `terraform validate` (run in the respective directory).
      - Static analysis: Tools like `tfsec` or `Checkov` can be used for security and compliance scanning (not explicitly defined in project files).
      - Integration testing: Typically involves deploying the infrastructure to a test environment in Azure and then verifying the deployed resources and their configuration through Azure portal, CLI, or scripted checks.
  - **Common CLI Commands:**
      - `terraform init`: Initializes a working directory containing Terraform configuration files.
      - `terraform validate`: Validates the syntax and arguments of configuration files.
      - `terraform plan`: Creates an execution plan, showing what actions Terraform will take.
      - `terraform apply`: Applies the changes required to reach the desired state of the configuration.
      - `terraform destroy`: Destroys all remote objects managed by a particular Terraform configuration.
      - `terraform output`: Reads and displays output values from a Terraform state file.
      - `terraform fmt`: Rewrites Terraform configuration files to a canonical format and style.

## 8\. API Endpoints (if applicable) 🌐

  - Not Applicable. This project uses Terraform to define and manage infrastructure; it does not expose any APIs itself but interacts with Azure APIs.

## 9\. Configuration & Customization 🛠️

  - **Main Configuration Files:**
      - Environment-specific variables: `environments/<env>/terraform.tfvars`, `environments/<env>/variables.tf`.
      - Root configuration variables: `project-root/vars.tfvars`, `project-root/variables.tf`.
      - Module input variables: `modules/<module_name>/variables.tf`.
  - **Key Configurable Parameters & Their Impact (examples from `environments/dev/variables.tf` and `environments/dev/terraform.tfvars`):**
      - `resource_group_name`: (string) Specifies the name of the Azure Resource Group to be created (for environments) or used (for root config).
      - `location`: (string) The Azure region where resources will be deployed (e.g., "eastasia").
      - `prefix`: (string) A prefix string used in naming various resources (e.g., "ldbs-dev").
      - `vnet_cidr`: (string) The CIDR block for the Virtual Network (e.g., "10.20.0.0/16").
      - `public_subnet_cidr`: (string) CIDR block for the public subnet.
      - `private_subnet_cidr`: (string) CIDR block for the private subnet.
      - `private_endpoint_subnet_cidr`: (string) CIDR block for the private endpoint subnet.
      - `pricing_tier` (for Databricks module): (string) Databricks workspace pricing tier (e.g., "premium", "standard").
      - `disable_public_ip` (for Databricks module): (bool) If `true`, enables Secure Cluster Connectivity (No Public IP) for the Databricks workspace.
      - `public_network_access` (for Databricks module): (string) Controls public network access to the Databricks workspace ("Enabled" or "Disabled").
      - `tags`: (map(string)) A map of tags to assign to Azure resources (e.g., `  { Environment = "Development", Project = "Azure Databricks" } `).
  - **Critical Environment Variables:**
      - Azure Authentication: Terraform requires Azure credentials to be configured in the environment where it runs. Common variables include:
          - `ARM_CLIENT_ID`
          - `ARM_CLIENT_SECRET`
          - `ARM_SUBSCRIPTION_ID`
          - `ARM_TENANT_ID`
            (These are for Service Principal authentication. Azure CLI authentication is also an option.)

## 10\. Common Workflows & Use Cases 🔄

  - **Workflow 1: Deploying a new environment (e.g., 'staging')**

    1.  Duplicate an existing environment directory (e.g., `cp -r environments/dev environments/staging`).
    2.  Navigate to the new environment directory: `cd environments/staging`.
    3.  Modify `terraform.tfvars` with parameters specific to the 'staging' environment (e.g., `resource_group_name = "learn_databricks_staging"`, `prefix = "ldbs-stg"`, different CIDR ranges).
    4.  Initialize Terraform: `terraform init`.
    5.  Create an execution plan: `terraform plan -out=staging.tfplan`.
    6.  Review the plan to ensure it reflects the intended creation of new 'staging' resources.
    7.  Apply the plan: `terraform apply "staging.tfplan"`.
    8.  Staging environment resources are provisioned in Azure, and outputs like `databricks_workspace_url` are available.

  - **Workflow 2: Updating an existing environment (e.g., modify Databricks SKU in 'dev')**

    1.  Navigate to the environment directory: `cd environments/dev`.
    2.  Edit `terraform.tfvars` and change the value for `pricing_tier` (e.g., from "premium" to "standard").
    3.  Create an execution plan: `terraform plan -out=update_sku.tfplan`.
    4.  Review the plan to confirm that Terraform intends to modify the Databricks workspace SKU.
    5.  Apply the plan: `terraform apply "update_sku.tfplan"`.

  - **Workflow 3: Adding a new resource to a module (e.g., adding a new NSG rule to `modules/vnet`)**

    1.  Navigate to the module directory: `cd modules/vnet`.
    2.  Edit `main.tf` to add a new `security_rule` block within the `azurerm_network_security_group` resource.
    3.  (Optional) If the new rule requires new input variables, add them to `modules/vnet/variables.tf`.
    4.  Navigate to an environment directory that uses this module (e.g., `cd ../../environments/dev`).
    5.  If new variables were added to the module, update the module call in `environments/dev/main.tf` to pass values for these new variables.
    6.  Run `terraform plan -out=update_nsg.tfplan` to see the planned changes.
    7.  Apply the plan: `terraform apply "update_nsg.tfplan"`. The NSG in the 'dev' environment will be updated.

  - **Workflow 4: Destroying an environment (e.g., 'dev')**

    1.  Navigate to the environment directory: `cd environments/dev`.
    2.  (Caution: This will delete all resources defined for this environment in Azure).
    3.  Create a destruction plan: `terraform plan -destroy -out=destroy_dev.tfplan`.
    4.  Review the plan carefully to ensure only the 'dev' environment resources are targeted.
    5.  Execute the destruction: `terraform apply "destroy_dev.tfplan"` or `terraform destroy`.

## 11\. Known Issues & Limitations ⚠️

  - **Local Backend for State Files:** Each environment configuration (e.g., `environments/dev/providers.tf`) uses a `local` backend for `terraform.tfstate`. This setup is not ideal for collaborative team environments as it can lead to state file conflicts, data loss, or inconsistencies. A remote backend (e.g., Azure Storage Account with state locking via Azure Blob) is highly recommended for production and team use.
  - **Sensitive Data in State Files:** The `terraform.tfstate` files (e.g., `environments/dev/terraform.tfstate` contains an example) may store sensitive information in plain text, such as storage account access keys or detailed resource identifiers. Access to these state files must be strictly controlled. Using a secure remote backend can help mitigate some risks.
  - **Ambiguity between Root and Environment Configurations:** The project contains a root Terraform configuration (`project-root/*.tf`) that defines resources directly within an *existing* resource group, and also environment-specific configurations (`environments/*/*.tf`) that *create* new resource groups and deploy modularized resources into them.
      - The root `main.tf` uses `data "azurerm_resource_group" "main"`, implying it expects the RG to be pre-created.
      - The environment `main.tf` files use `resource "azurerm_resource_group" "main"`, creating the RG.
        The intended interplay or precedence between these two approaches should be clarified for consistent usage.
  - **Naming Conventions for Storage Account:** The `modules/storage/main.tf` includes a `local.adls_storage_account_name` that processes the prefix and suffix by lowercasing and removing hyphens to meet Azure Storage Account naming rules. Users need to be aware that the final storage account name might differ slightly from a simple concatenation if hyphens are used in the prefix/suffix.

## 12\. Logging & Monitoring 📜

  - **Logging Framework Used:**
      - Terraform CLI: Outputs execution details, plans, changes, and errors to `stdout/stderr` during operations like `plan` and `apply`.
      - Azure Platform: Azure services (Databricks, VNet, Storage Accounts, etc.) generate their own logs and metrics.
  - **Key Log Locations/Formats:**
      - **Terraform Logs:** Console output. This can be captured by redirecting to a file.
      - **Terraform State File (`terraform.tfstate`):** While not a log in the traditional sense, it's a critical JSON file that records the current state of managed infrastructure for a given configuration (e.g., `environments/dev/terraform.tfstate`).
      - **Azure Activity Logs:** Available in the Azure portal/CLI; tracks all management-level operations performed on Azure resources (e.g., creation, deletion, updates initiated by Terraform).
      - **Azure Diagnostic Logs:** Specific to each Azure service, providing more detailed operational logs (e.g., Databricks audit logs, NSG flow logs if enabled). These need to be configured to be collected (e.g., sent to Log Analytics, Storage Account, or Event Hub).
  - **Monitoring Tools Used (if any):**
      - Terraform itself does not provide long-term monitoring; monitoring is primarily done through Azure's native tools.
      - **Azure Monitor:** The central service in Azure for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. Used for:
          - Metrics: Performance and utilization of deployed resources.
          - Log Analytics: Querying and analyzing logs collected from various Azure services.
          - Alerts: Setting up notifications based on metric thresholds or log queries.
  - **Key Metrics Tracked:**
      - **Terraform Operations:**
          - Execution time of `plan` and `apply`.
          - Number of resources added, changed, or destroyed.
      - **Azure Resource Metrics (via Azure Monitor):**
          - For Databricks: Cluster utilization, job status, active users.
          - For VNets/NSGs: Network traffic, NSG rule hit counts (if flow logs enabled & analyzed).
          - For Storage Accounts: Capacity, transaction counts, latency, availability.
          - General: CPU utilization, memory usage, disk I/O, costs associated with the deployed resources.

## 13\. Glossary of Terms & Abbreviations 📖

  - **ADLS Gen2:** Azure Data Lake Storage Gen2.
  - **ARM:** Azure Resource Manager. The deployment and management service for Azure.
  - **CIDR:** Classless Inter-Domain Routing. A method for allocating IP addresses and IP routing.
  - **Databricks Workspace:** An analytics platform optimized for the Microsoft Azure cloud services platform.
  - **HCL:** HashiCorp Configuration Language. The language used to write Terraform configuration files.
  - **IaC:** Infrastructure as Code. Managing and provisioning infrastructure through machine-readable definition files.
  - **`main.tf`:** A common conventional name for the primary Terraform configuration file in a directory or module.
  - **Module (Terraform):** A self-contained package of Terraform configurations that are managed as a group.
  - **NSG:** Azure Network Security Group. Used to filter network traffic to and from Azure resources in an Azure virtual network.
  - **`outputs.tf`:** A conventional name for a Terraform file that declares output values for a configuration.
  - **Private DNS Zone:** Provides name resolution for virtual machines (VMs) within a virtual network and between virtual networks without needing to create and manage custom DNS solutions.
  - **Private Endpoint:** A network interface that uses a private IP address from your virtual network, effectively bringing an Azure service into your VNet.
  - **Provider (Terraform):** A plugin that Terraform uses to manage an external API (e.g., `azurerm` for Azure).
  - **Resource (Terraform):** An infrastructure object managed by Terraform, such as a virtual network, a compute instance, or a DNS record.
  - **SCC:** Secure Cluster Connectivity (No Public IP) for Azure Databricks, ensuring clusters do not have public IP addresses.
  - **State File (`terraform.tfstate`):** A file (usually JSON) that Terraform uses to store the state of the managed infrastructure.
  - **Subnet:** A range of IP addresses in a VNet.
  - **Tags (Azure):** Metadata elements that you apply to your Azure resources for organization and categorization.
  - **Terraform:** An open-source Infrastructure as Code software tool created by HashiCorp.
  - **`.tfvars` file:** A file used to define values for Terraform input variables.
  - **`variables.tf`:** A conventional name for a Terraform file that declares input variables for a configuration.
  - **VNet:** Azure Virtual Network. Enables Azure resources to securely communicate with each other, the internet, and on-premises networks.

## 14\. Contribution Guide & Coding Standards (Optional) 🤝

  - **How to Contribute:** Not explicitly specified. A typical process would involve:
    1.  Forking the repository (if applicable).
    2.  Creating a new feature or bugfix branch from the main development branch.
    3.  Making changes in the branch.
    4.  Committing changes with clear messages.
    5.  Pushing the branch to the remote repository.
    6.  Submitting a Pull Request (PR) for review.
  - **Code Style Guidelines:**
      - Follow Terraform's canonical format and style; use `terraform fmt` to ensure consistency.
      - Employ consistent naming conventions for resources, variables, and outputs (e.g., `prefix-resource_type-name-suffix` or `snake_case_for_variables`). The project uses a mix, e.g. `resource_group_name` for variables and `local.nsg_name` concatenating prefix and suffix for resource names.
      - Use `locals` blocks for complex expressions or to define values used multiple times within a module/configuration to improve readability and maintainability.
      - Write clear descriptions for variables and outputs.
  - **Branching Strategy:** Not specified. Common strategies include Gitflow (with feature, develop, release, main branches) or GitHub Flow (simpler, main branch with feature branches).
  - **Pull Request (PR) Process:** Not specified. A standard PR process would likely involve:
      - A clear description of the changes and the problem being solved.
      - Review by at least one other team member.
      - Automated checks (e.g., `terraform validate`, static analysis, linting).
      - Successful execution of `terraform plan` (and potentially `apply` in a test environment).
      - Merging the PR into the main development branch once approved.