output "resource_group_name" {
    value       = module.rg.name
}

output "resource_group_id" {
    value       = module.rg.id
}

output "storagename" {
    value       = azurerm_storage_account.sa.name
}
output "storage_id" {
    value       = azurerm_storage_account.sa.id
}

