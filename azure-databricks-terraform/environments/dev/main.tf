resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "../../modules/vnet"

  resource_group_name                 = azurerm_resource_group.main.name
  location                            = azurerm_resource_group.main.location
  prefix                              = var.prefix
  vnet_cidr                           = var.vnet_cidr
  public_subnet_cidr                  = var.public_subnet_cidr
  private_subnet_cidr                 = var.private_subnet_cidr
  private_endpoint_subnet_cidr        = var.private_endpoint_subnet_cidr
  nsg_name_suffix                     = var.nsg_name_suffix
  vnet_name_suffix                    = var.vnet_name_suffix
  public_subnet_name_suffix           = var.public_subnet_name_suffix
  private_subnet_name_suffix          = var.private_subnet_name_suffix
  private_endpoint_subnet_name_suffix = var.private_endpoint_subnet_name_suffix
  tags                                = var.tags
}

module "databricks" {
  source = "../../modules/databricks"

  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  prefix                            = var.prefix
  workspace_name_suffix             = var.workspace_name_suffix
  pricing_tier                      = var.pricing_tier
  public_network_access             = var.public_network_access
  disable_public_ip                 = var.disable_public_ip
  virtual_network_id                = module.vnet.virtual_network_id
  vnet_name                         = module.vnet.virtual_network_name
  public_subnet_name                = module.vnet.public_subnet_name
  private_subnet_name               = module.vnet.private_subnet_name
  public_subnet_nsg_association_id  = module.vnet.public_subnet_nsg_association_id
  private_subnet_nsg_association_id = module.vnet.private_subnet_nsg_association_id
  private_endpoint_subnet_id        = module.vnet.private_endpoint_subnet_id
  create_private_endpoint           = true
  tags                              = var.tags

  dependencies = [
    module.vnet.public_subnet_nsg_association_id,
    module.vnet.private_subnet_nsg_association_id,
    module.vnet.private_endpoint_subnet_id
  ]
}

module "storage" {
  source = "../../modules/storage"

  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  prefix                           = var.prefix
  adls_storage_account_name_suffix = var.adls_storage_account_name_suffix
  tags                             = var.tags
}

resource "azurerm_storage_container" "databricks_inbound_container" {
  name                  = "databricks-inbound"
  storage_account_name  = module.storage.adls_storage_account_name
  container_access_type = "private"
}
