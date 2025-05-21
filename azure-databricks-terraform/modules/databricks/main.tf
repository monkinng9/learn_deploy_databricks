resource "azurerm_databricks_workspace" "main" {
  name                          = local.workspace_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.pricing_tier
  tags                          = var.tags
  public_network_access_enabled = var.public_network_access == "Enabled"

  network_security_group_rules_required = (var.public_network_access == "Enabled" ? "AllRules" : "NoAzureDatabricksRules")

  custom_parameters {
    virtual_network_id  = var.virtual_network_id
    public_subnet_name  = var.public_subnet_name
    private_subnet_name = var.private_subnet_name

    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_association_id
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_association_id

    no_public_ip = var.disable_public_ip
  }

  depends_on = [
    var.dependencies
  ]
}

resource "azurerm_private_endpoint" "main" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = local.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${local.private_endpoint_name}-conn"
    private_connection_resource_id = azurerm_databricks_workspace.main.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = local.pvt_endpoint_dns_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.main[0].id]
  }

  depends_on = [azurerm_databricks_workspace.main]
}

resource "azurerm_private_dns_zone" "main" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = local.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  count                 = var.create_private_endpoint ? 1 : 0
  name                  = "${replace(local.private_dns_zone_name, ".", "-")}-${var.vnet_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main[0].name
  tags                  = var.tags
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false

  depends_on = [
    azurerm_private_dns_zone.main,
  ]
}

locals {
  workspace_name               = "${var.prefix}-${var.workspace_name_suffix}"
  private_endpoint_name        = "${local.workspace_name}-pvtEndpoint"
  private_dns_zone_name        = "privatelink.azuredatabricks.net"
  pvt_endpoint_dns_group_name  = "defaultGroup"
}
