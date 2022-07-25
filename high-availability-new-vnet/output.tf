
output "public-ip" {
  value = "${azurerm_public_ip.public-ip.*.ip_address}"
}

output "cluster-vip" {
  value = azurerm_public_ip.cluster-vip.ip_address
}

output "cluster-vip-private" {
  value = azurerm_network_interface.nic_vip.ip_configuration[1].private_ip_address
}

output "public-ip-lb" {
  value = azurerm_public_ip.public-ip-lb.ip_address
}

output "backend-lb-internal-address" {
  value = azurerm_lb.backend-lb.private_ip_address
}

#output "network_security_group_id_db" {
#  value = azurerm_network_security_group.my-db-nsg.id
#}
#
#output "network_security_group_name_db" {
#  value = azurerm_network_security_group.my-db-nsg.name
#}
#
#output "network_security_group_id_appweb" {
#  value = azurerm_network_security_group.my-app-web-nsg.id
#}
#
#output "network_security_group_name_appweb" {
#  value = azurerm_network_security_group.my-app-web-nsg.name
#}

output "network_security_group_id_CGNS" {
  value = module.network-security-group.network_security_group_id
}

output "network_security_group_name_CGNS" {
  value = module.network-security-group.network_security_group_name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}