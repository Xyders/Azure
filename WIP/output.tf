output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.myterraformvm.public_ip_address
}
output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}
# Create Service Principal to onboard Dome9
#output "name" {
#  value       = azuread_service_principal.main.display_name
#  description = "The display name of the Azure AD application."
#}
#output "application_id" {
#  value       = azuread_application.main.application_id
#  description = "The client (application) ID of the service principal."
#}
#output "client_id" {
#  value       = azuread_application.main.application_id
#  description = "Echoes the `application_id` output value, for convenience if passing the result of this module elsewhere as an object."
#}
#output "object_id" {
#  value       = azuread_service_principal.main.id
#  description = "The Object ID of the service principal."
#}
#output "tenant_id" {
#  value       = data.azurerm_client_config.main.tenant_id
#  description = "Echoes back the tenant (directory) ID, for convenience if passing the result of this module elsewhere as an object."
#}
#output "password" {
#  value       = azuread_service_principal_password.main[0].value
#  sensitive   = true
#  description = "The password for the service principal."
#}
#output "client_secret" {
#  value       = azuread_service_principal_password.main[0].value
#  sensitive   = true
#  description = "Echoes the `password` output value, for convenience if passing the result of this module elsewhere as an object."
#}