
output "name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.rg.id
}

output "location" {
  description = "Resource Group location"
  value       = azurerm_resource_group.rg.location
}
