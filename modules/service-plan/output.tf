output "service_plan_id" {
  value = azurerm_service_plan.this.id
}

output "identity_id" {
  value = azurerm_user_assigned_identity.this.id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.this.principal_id
}

