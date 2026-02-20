output "resource_group_name" {
    value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
    value       = azurerm_resource_group.rg.id
}

output "storagename" {
    value       = azurerm_storage_account.sa.name
}
output "storage_id" {
    value       = azurerm_storage_account.sa.id
}