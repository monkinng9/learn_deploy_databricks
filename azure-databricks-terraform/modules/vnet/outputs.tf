output "virtual_network_name" {
  description = "Name of the deployed Virtual Network."
  value       = azurerm_virtual_network.main.name
}

output "virtual_network_id" {
  description = "ID of the deployed Virtual Network."
  value       = azurerm_virtual_network.main.id
}

output "network_security_group_name" {
  description = "Name of the deployed Network Security Group."
  value       = azurerm_network_security_group.main.name
}

output "network_security_group_id" {
  description = "ID of the deployed Network Security Group."
  value       = azurerm_network_security_group.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = azurerm_subnet.public.id
}

output "public_subnet_name" {
  description = "Name of the public subnet."
  value       = azurerm_subnet.public.name
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = azurerm_subnet.private.id
}

output "private_subnet_name" {
  description = "Name of the private subnet."
  value       = azurerm_subnet.private.name
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet."
  value       = azurerm_subnet.private_endpoint.id
}

output "public_subnet_nsg_association_id" {
  description = "ID of the public subnet NSG association."
  value       = azurerm_subnet_network_security_group_association.public.id
}

output "private_subnet_nsg_association_id" {
  description = "ID of the private subnet NSG association."
  value       = azurerm_subnet_network_security_group_association.private.id
}
