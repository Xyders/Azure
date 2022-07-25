#output "public_ip_address" {
#  value = azurerm_linux_virtual_machine.myterraformvm.public_ip_address
#}
#output "tls_private_key" {
#  value     = tls_private_key.example_ssh.private_key_pem
#  sensitive = true
#}


######################
## Network - Output ##
######################

output "network_resource_group_id" {
  value = azurerm_resource_group.network-rg.id
}

output "network_vnet_id" {
  value = azurerm_virtual_network.myterraformnetwork00.id
}

output "network_subnet_id" {
  value = azurerm_subnet.myterraformsubnet00-0.id
}


##########################
## Azure Linux - Output ##
##########################

output "linux_vm_name" {
  description = "Virtual Machine name"
  value       = azurerm_linux_virtual_machine.linux-vm.name
}

output "linux_vm_ip_address" {
  description = "Virtual Machine name IP Address"
  value       = azurerm_public_ip.linux-vm-ip.ip_address
}

output "linux_vm_admin_username" {
  description = "Username password for the Virtual Machine"
  value       = var.linux_admin_username
}

output "linux_vm_admin_password" {
  description = "Administrator password for the Virtual Machine"
  value       = random_password.linux-vm-password.result
  sensitive   = true
}

