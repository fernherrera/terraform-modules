output "id" {
  description = "The ID of the Linux Web App."
  value       = azurerm_linux_web_app.web_app.id
}

output "outbound_ip_addresses" {
  description = "A comma separated list of outbound IP addresses"
  value       = azurerm_linux_web_app.web_app.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "A comma separated list of outbound IP addresses. not all of which are necessarily in use"
  value       = azurerm_linux_web_app.web_app.possible_outbound_ip_addresses
}

output "site_credential" {
  description = "The output of any site credentials"
  value       = azurerm_linux_web_app.web_app.site_credential
}

output "web_app_id" {
  description = "The ID of the App Service."
  value       = azurerm_linux_web_app.web_app.id
}

output "web_app_name" {
  description = "The name of the App Service."
  value       = azurerm_linux_web_app.web_app.name
}

output "web_identity" {
  description = "The managed identity block from the Function app"
  value       = azurerm_linux_web_app.web_app.identity
}