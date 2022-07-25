//********************** Internal subnets and route tables **************************//
resource "azurerm_subnet" "web_subnet" {
  name                 = "webSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_subnet" "app_subnet" {
  name                 = "appSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.4.0/24"]
}
resource "azurerm_subnet" "db_subnet" {
  name                 = "dbSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.5.0/24"]
}

locals { // locals for 'next_hop_type' allowed values
  next_hop_type_allowed_values = [
    "VirtualNetworkGateway",
    "VnetLocal",
    "Internet",
    "VirtualAppliance",
    "None"
  ]
}

resource "azurerm_route_table" "app_rt" {
  name = azurerm_subnet.app_subnet.name
  location = var.location
  resource_group_name = var.resource_group_name

  route {
    name = "app-local"
    address_prefix = azurerm_subnet.app_subnet.address_prefix
    next_hop_type = local.next_hop_type_allowed_values[1]
  }
  route {
    name = "app-subnet-to-other-subnets"
    address_prefix = var.address_space
    next_hop_type = local.next_hop_type_allowed_values[3]
    next_hop_in_ip_address = "${azurerm_lb.backend-lb.private_ip_address}"
  }
  route {
    name = "app-subnet-default"
    address_prefix = "0.0.0.0/0"
    next_hop_type = local.next_hop_type_allowed_values[3]
    next_hop_in_ip_address = "${azurerm_lb.backend-lb.private_ip_address}"
  }
}

resource "azurerm_subnet_route_table_association" "app_association" {
  subnet_id = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.app_rt.id
}

resource "azurerm_route_table" "web_rt" {
  name = azurerm_subnet.web_subnet.name
  location = var.location
  resource_group_name = var.resource_group_name

  route {
    name = "web-local"
    address_prefix = azurerm_subnet.web_subnet.address_prefix
    next_hop_type = local.next_hop_type_allowed_values[1]
  }
  route {
    name = "web-subnet-to-other-subnets"
    address_prefix = var.address_space
    next_hop_type = local.next_hop_type_allowed_values[3]
    next_hop_in_ip_address = "${azurerm_lb.backend-lb.private_ip_address}"
  }
  route {
    name = "web-subnet-default"
    address_prefix = "0.0.0.0/0"
    next_hop_type = local.next_hop_type_allowed_values[3]
    next_hop_in_ip_address = "${azurerm_lb.backend-lb.private_ip_address}"
  }
}

resource "azurerm_subnet_route_table_association" "web_association" {
  subnet_id = azurerm_subnet.web_subnet.id
  route_table_id = azurerm_route_table.web_rt.id
}

# Load Balancing Rules of the External Load Balancer
# Example 1: Frontend Web:443 Backend port 8081
# Example 2: Frontend App:80  Backend port 8083
#resource "azurerm_route_table" "frontend" {
#  name = azurerm_subnet.subnet[0].name
#  location = var.location
#  resource_group_name = var.resource_group_name
#
#  route {
#    name = "Local-Subnet"
#    address_prefix = azurerm_subnet.subnet[0].address_prefix
#    next_hop_type = local.next_hop_type_allowed_values[1]
#  }
#  route {
#    name = "To-Internal"
#    address_prefix = var.address_space
#    next_hop_type = local.next_hop_type_allowed_values[4]
#  }
#}

resource "azurerm_subnet_route_table_association" "frontend_association" {
  subnet_id = azurerm_subnet.subnet[0].id
  route_table_id = azurerm_route_table.frontend.id
}



#//********************** Security Groups **************************//
## Create Application Security Group
#resource "azurerm_application_security_group" "app_web_asg" {
#  name                = "my-appweb-asg"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#
#  tags = {
#    type = "appweb"
#  }
#}
#
## Create Network Security Group and rule
#resource "azurerm_network_security_group" "my-db-nsg" {
#  name                = "mydbnsg"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#
#  security_rule {
#    name                       = "AllowDBInbound"
#    priority                   = 100
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_ranges    = ["5432","3306","1433"]
#    source_application_security_group_ids = ["${azurerm_application_security_group.app_web_asg.id}"]
##    source_address_prefixes    = ["10.0.3.0/24","10.0.4.0/24"]
#    destination_address_prefix = "*"
#    description                = "Allow DB inbound connections"
#  }
#
#  security_rule {
#    name                       = "DenyAny"
#    priority                   = 101
#    direction                  = "Inbound"
#    access                     = "Deny"
#    protocol                   = "*"
#    source_port_range          = "*"
#    destination_port_range     = "*"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#    description                = "Deny any inbound"
#  }
#
#  security_rule {
#    name                       = "BlockOutbound"
#    priority                   = 1051
#    direction                  = "Outbound"
#    access                     = "Deny"
#    protocol                   = "*"
#    source_port_range          = "*"
#    destination_port_range     = "*"
#    source_address_prefix      = "*"
#    destination_address_prefix = "Internet"
#    description                = "Deny outbound connections"
#  }
#
##  tags = merge(local.shared_tags)
#}
#
#resource "azurerm_network_security_group" "my-app-web-nsg" {
#  name                = "myappwebnsg"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#
#  security_rule {
#    name                       = "AllowAppWebInbound"
#    priority                   = 100
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_ranges    = ["8081","8083"]
#    source_address_prefix      = "${azurerm_lb.backend-lb.private_ip_address}"
#    destination_address_prefix = "*"
#    description                = "Allow App and Web inbound connections"
#  }
#
#  security_rule {
#    name                       = "DenyAny"
#    priority                   = 101
#    direction                  = "Inbound"
#    access                     = "Deny"
#    protocol                   = "*"
#    source_port_range          = "*"
#    destination_port_range     = "*"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#    description                = "Deny any inbound"
#  }
#}
#
#resource "azurerm_subnet_network_security_group_association" "security_group_app_association" {
#  depends_on = [module.vnet, azurerm_subnet.app_subnet]
#  subnet_id = azurerm_subnet.app_subnet.id
#  network_security_group_id = azurerm_network_security_group.my-app-web-nsg.id
#}
#
#resource "azurerm_subnet_network_security_group_association" "security_group_web_association" {
#  depends_on = [module.vnet, azurerm_subnet.web_subnet]
#  subnet_id = azurerm_subnet.web_subnet.id
#  network_security_group_id = azurerm_network_security_group.my-app-web-nsg.id
#}
#
#
## Connect the security group to the network interface
#resource "azurerm_network_interface_application_security_group_association" "app_example" {
#  network_interface_id          = azurerm_network_interface.app_nic.id
#  application_security_group_id = azurerm_application_security_group.app_web_asg.id
#}
#resource "azurerm_network_interface_application_security_group_association" "web_example" {
#  network_interface_id          = azurerm_network_interface.web_nic.id
#  application_security_group_id = azurerm_application_security_group.app_web_asg.id
#}
#resource "azurerm_network_interface_security_group_association" "db_example" {
#  network_interface_id      = azurerm_network_interface.db_nic.id
#  network_security_group_id = azurerm_network_security_group.my-db-nsg.id
#}


# Create network interface
resource "azurerm_network_interface" "app_nic" {
  name                = "appNIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "appNicConfiguration"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "web_nic" {
  name                = "webNIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "webNicConfiguration"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "db_nic" {
  name                = "dbNIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "dbNicConfiguration"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "web_vm" {
  name                  = "webvm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.web_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myWebDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "webvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}

resource "azurerm_linux_virtual_machine" "app_vm" {
  name                  = "appvm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.app_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myAppDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "appvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}

resource "azurerm_linux_virtual_machine" "db_vm" {
  name                  = "dbvm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myDBDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "dbvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}




