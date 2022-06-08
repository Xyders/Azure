


resource "random_pet" "rg-name" {
  prefix    = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name      = random_pet.rg-name.id
  location  = var.resource_group_location
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork00" {
  name                = "myVnet00"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_virtual_network" "myterraformnetwork01" {
  name                = "myVnet01"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet00" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork00.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "myterraformsubnet01" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork01.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet00.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = "myVM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size                  = var.vmsize

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
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



# # create service principal used for onboarding Dome9
# data "azurerm_client_config" "main" {}
# data "azurerm_subscription" "main" {}
# data "azuread_client_config" "current" {}
# data "azuread_application_published_app_ids" "well_known" {}
# 
# resource "azuread_service_principal" "msgraph" {
#   application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
#   use_existing = true
# }


# # Create an application
# resource "azuread_application" "main" {
#   display_name               = var.name
# #  available_to_other_tenants = false
# #  reply_urls                 = [var.RedirectURI]
# #  type                       = "webapp/api"
#   owners                     = [data.azuread_client_config.current.object_id]
# }
# Create a service principal
#resource "azuread_service_principal" "main" {
#  application_id                = azuread_application.main.application_id
#  app_role_assignment_required  = false
#  owners                        = [data.azuread_client_config.current.object_id]
#}
# resource "time_rotating" "main" {
#   rotation_rfc3339 = var.end_date
#   rotation_years   = var.years
#   triggers = {
#     end_date = var.end_date
#     years    = var.years
#   }
# }
# resource "random_password" "main" {
#   count  = var.password == "" ? 1 : 0
#   length = 32
#   keepers = {
#     rfc3339 = time_rotating.main.id
#   }
# }
# resource "azuread_service_principal_password" "main" {
#   count                = var.password != null ? 1 : 0
#   service_principal_id = azuread_service_principal.main.id
#   value                = coalesce(var.password, random_password.main[0].result)
#   end_date             = time_rotating.main.rotation_rfc3339
# }
# Assign a Contributor role
#resource "azurerm_role_assignment" "main" {
#  scope                = data.azurerm_subscription.main.id
#  role_definition_name = "Contributor"
#  principal_id         = azuread_service_principal.main.object_id
#  count              = var.role != "" ? length(local.scopes) : 0
#  scope              = local.scopes[count.index]
#  role_definition_id = format("%s%s", data.azurerm_subscription.main.id, data.azurerm_role_definition.main[0].id)
#  principal_id       = azuread_service_principal.main.id
#}