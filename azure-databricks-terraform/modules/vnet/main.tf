resource "azurerm_network_security_group" "main" {
  name                = local.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

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
    name                       = "AllowDatabricksInboundSsh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "VirtualNetwork"
    description                = "Allow SSH from Databricks control plane to workers (Network Intent Policy)."
  }

  security_rule {
    name                       = "AllowDatabricksInboundProxy"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5557"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "VirtualNetwork"
    description                = "Allow Proxy from Databricks control plane to workers (Network Intent Policy)."
  }

  security_rule {
    name                       = "AllowDatabricksControlPlaneOutbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "8443-8451", "3306"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureDatabricks"
    description                = "Required for workers communication with Databricks control plane."
  }

  security_rule {
    name                       = "AllowSqlOutbound"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
    description                = "Required for workers communication with Azure SQL services."
  }

  security_rule {
    name                       = "AllowStorageOutbound"
    priority                   = 220
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
    description                = "Required for workers communication with Azure Storage services."
  }

  security_rule {
    name                       = "AllowVnetOutBound"
    priority                   = 230
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
    priority                   = 240
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9093"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "EventHub"
    description                = "Required for worker communication with Azure Eventhub services."
  }
}

resource "azurerm_virtual_network" "main" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags

  depends_on = [azurerm_network_security_group.main]
}

resource "azurerm_subnet" "public" {
  name                 = local.public_subnet_name
  resource_group_name  = var.resource_group_name
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
  resource_group_name  = var.resource_group_name
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
  name                                      = local.private_endpoint_subnet_name
  resource_group_name                       = var.resource_group_name
  virtual_network_name                      = azurerm_virtual_network.main.name
  address_prefixes                          = [var.private_endpoint_subnet_cidr]
  private_endpoint_network_policies_enabled = false
}

locals {
  nsg_name                     = "${var.prefix}-${var.nsg_name_suffix}"
  vnet_name                    = "${var.prefix}-${var.vnet_name_suffix}"
  public_subnet_name           = "${var.prefix}-${var.public_subnet_name_suffix}"
  private_subnet_name          = "${var.prefix}-${var.private_subnet_name_suffix}"
  private_endpoint_subnet_name = "${var.prefix}-${var.private_endpoint_subnet_name_suffix}"
}
