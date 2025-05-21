resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location # This location will be used for the new resource group.
}

locals {
  # All resources will now use the location of the created/managed resource group.
  actual_location = azurerm_resource_group.main.location

  # Construct resource names using prefix and suffix variables
  nsg_name                     = "${var.prefix}-${var.nsg_name_suffix}"
  vnet_name                    = "${var.prefix}-${var.vnet_name_suffix}"
  public_subnet_name           = "${var.prefix}-${var.public_subnet_name_suffix}"
  private_subnet_name          = "${var.prefix}-${var.private_subnet_name_suffix}"
  private_endpoint_subnet_name = "${var.prefix}-${var.private_endpoint_subnet_name_suffix}"
  adls_storage_account_name    = "${var.prefix}${var.adls_storage_account_name_suffix}" # Storage account names have stricter naming rules (e.g., no hyphens sometimes, length limits) and must be globally unique.
  workspace_name               = "${var.prefix}-${var.workspace_name_suffix}"
  private_endpoint_name        = "${local.workspace_name}-pvtEndpoint" # PE name often tied to workspace name

  private_dns_zone_name       = "privatelink.azuredatabricks.net" # Standard for Databricks Private Link
  pvt_endpoint_dns_group_name = "defaultGroup"                    # Internal name for the DNS group in PE
}

resource "azurerm_network_security_group" "main" {
  name                = local.nsg_name
  location            = local.actual_location
  resource_group_name = azurerm_resource_group.main.name # Use the name of the created/managed RG

  security_rule {
    name                       = "AllowVnetInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    description                = "Required for worker nodes communication within a cluster."
  }

  security_rule {
    name                       = "AllowDatabricksControlPlaneOutbound"
    priority                   = 100 # Note: Consider unique priorities if they are in the same direction and overlap.
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "8443-8451", "3306"] # Ensure 3306 is for Databricks control plane, not general SQL.
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureDatabricks"
    description                = "Required for workers communication with Databricks control plane."
  }

  security_rule {
    name                       = "AllowSqlOutbound"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql" # Service Tag for Azure SQL
    description                = "Required for workers communication with Azure SQL services."
  }

  security_rule {
    name                       = "AllowStorageOutbound"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443" # HTTPS for Storage
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage" # Service Tag for Azure Storage
    description                = "Required for workers communication with Azure Storage services."
  }

  security_rule {
    name                       = "AllowVnetOutBound"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    description                = "Required for worker nodes communication within a cluster."
  }

  security_rule {
    name                       = "AllowEventHubOutbound"
    priority                   = 104
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9093" # AMQPS for Event Hub
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "EventHub" # Service Tag for Azure Event Hub
    description                = "Required for worker communication with Azure Eventhub services."
  }
}

resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  location            = local.actual_location
  resource_group_name = azurerm_resource_group.main.name # Use the name of the created/managed RG
  address_space       = [var.vnet_cidr]

  # depends_on is not strictly necessary here as Terraform infers dependencies,
  # but it doesn't hurt if you prefer explicit declaration.
  depends_on = [azurerm_network_security_group.main]
}

resource "azurerm_subnet" "public" {
  name                 = local.public_subnet_name
  resource_group_name  = azurerm_resource_group.main.name # Use the name of the created/managed RG
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]

  delegation {
    name = "databricks-del-public"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet" "private" {
  name                 = local.private_subnet_name
  resource_group_name  = azurerm_resource_group.main.name # Use the name of the created/managed RG
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidr]

  delegation {
    name = "databricks-del-private"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet" "private_endpoint" {
  name                              = local.private_endpoint_subnet_name
  resource_group_name               = azurerm_resource_group.main.name # Use the name of the created/managed RG
  virtual_network_name              = azurerm_virtual_network.main.name
  address_prefixes                  = [var.private_endpoint_subnet_cidr]
  private_endpoint_network_policies = "Disabled" # Required for Private Endpoints
}

resource "azurerm_databricks_workspace" "main" {
  name                          = local.workspace_name
  location                      = local.actual_location
  resource_group_name           = azurerm_resource_group.main.name
  sku                           = var.pricing_tier
  public_network_access_enabled = var.public_network_access == "Enabled"

  # Moved network_security_group_rules_required to be a top-level argument.
  # Its value is set conditionally:
  # - "NoAzureDatabricksRules" if public_network_access is disabled (to resolve the previous 400 error).
  # - "AllRules" if public_network_access is enabled.
  network_security_group_rules_required = (var.public_network_access == "Enabled" ? "AllRules" : "NoAzureDatabricksRules")

  custom_parameters {
    # VNet Injection parameters:
    virtual_network_id  = azurerm_virtual_network.main.id # Reference the VNet ID
    public_subnet_name  = azurerm_subnet.public.name      # Reference the public subnet NAME
    private_subnet_name = azurerm_subnet.private.name     # Reference the private subnet NAME

    # NSG association IDs:
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id

    no_public_ip = var.disable_public_ip # For VNet Injection with no Public IP (Secure Cluster Connectivity)
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.public,
    azurerm_subnet_network_security_group_association.private,
    azurerm_subnet.private_endpoint, # Ensure PE subnet is created before workspace if PE is for this workspace
  ]
}

resource "azurerm_private_endpoint" "main" {
  name                = local.private_endpoint_name
  location            = local.actual_location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "${local.private_endpoint_name}-conn"
    private_connection_resource_id = azurerm_databricks_workspace.main.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"] # For Databricks UI/API private link
  }

  private_dns_zone_group {
    name                 = local.pvt_endpoint_dns_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.main.id]
  }

  depends_on = [azurerm_databricks_workspace.main] # Private Endpoint depends on the workspace existing
}

resource "azurerm_private_dns_zone" "main" {
  name                = local.private_dns_zone_name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "${replace(local.private_dns_zone_name, ".", "-")}-${local.vnet_name}-link" # Unique link name
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false # Typically false for Private Link DNS zones managed this way

  depends_on = [
    azurerm_private_dns_zone.main,
    azurerm_virtual_network.main
  ]
}

resource "azurerm_storage_account" "adls" {
  name                     = local.adls_storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = local.actual_location
  account_tier             = "Standard"
  account_replication_type = "LRS"       # Locally-redundant storage
  account_kind             = "StorageV2" # Required for HNS
  is_hns_enabled           = true        # Enables Azure Data Lake Storage Gen2

  # depends_on = [azurerm_resource_group.main] # Implicit dependency
  tags = var.tags # Assuming you might add a tags variable later, or remove this line if not needed.
}
