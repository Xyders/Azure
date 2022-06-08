
output "public-ip" {
  value = "${azurerm_public_ip.public-ip.*.ip_address}"
}

output "cluster-vip" {
  value = azurerm_public_ip.cluster-vip.ip_address
}

output "public-ip-lb" {
  value = azurerm_public_ip.public-ip-lb.ip_address
}

output "frontend-lb-internal-address" {
  value = azurerm_lb.frontend-lb.private_ip_address
}

output "backend-lb-internal-address" {
  value = azurerm_lb.backend-lb.private_ip_address
}

output "network_security_group_id" {
  value = azurerm_network_security_group.app_web_nsg.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.app_web_nsg.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}