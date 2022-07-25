

variable "resource_group_name_prefix" {
  default       = "rg"
  description   = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
variable "resource_group_location" {
  default = "eastus"
  description   = "Location of the resource group."
}
variable "username" {
    description = "Username for Virtual Machines"
    default     = "azureuser"
}
variable "vmsize" {
    description = "Size of the VMs"
    default     = "Standard_DS1_v2"
}


################################
## Azure Provider - Variables ##
################################

# Azure authentication variables

variable "azure-subscription-id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "azure-client-id" {
  type        = string
  description = "Azure Client ID"
}

variable "azure-client-secret" {
  type        = string
  description = "Azure Client Secret"
}

variable "azure-tenant-id" {
  type        = string
  description = "Azure Tenant ID"
}


##############################
## Core Network - Variables ##
##############################

variable "network-vnet-cidr" {
  type        = string
  description = "The CIDR of the network VNET"
}

variable "network-subnet-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
}


################################
## Azure Linux VM - Variables ##
################################

variable "linux_vm_size" {
  type        = string
  description = "Size (SKU) of the virtual machine to create"
}

variable "linux_admin_username" {
  type        = string
  description = "Username for Virtual Machine administrator account"
  default     = ""
}

variable "linux_admin_password" {
  type        = string
  description = "Password for Virtual Machine administrator account"
  default     = ""
}



######################
## Ubuntu Variables ##
######################

variable "linux_vm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "Canonical"
}

variable "linux_vm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  #default     = "UbuntuServer"
  # can be found by using "az vm image list -p canonical -o table --all | grep 20_04-lts | grep -v gen2"
  default     = "0001-com-ubuntu-server-focal"
}

variable "linux_vm_image_offer_20" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "0001-com-ubuntu-server-focal"
}

variable "ubuntu_1604_sku" {
  type        = string
  description = "SKU for Ubuntu 16.04 LTS"
  default     = "16.04-lts"
}

variable "ubuntu_1604_gen2_sku" {
  type        = string
  description = "SKU for Ubuntu 16.04 LTS Gen2"
  default     = "16_04-lts-gen2"
}

variable "ubuntu_1804_sku" {
  type        = string
  description = "SKU for Ubuntu 18.04 LTS"
  default     = "18.04-lts"
}

variable "ubuntu_1804_gen2_sku" {
  type        = string
  description = "SKU for Ubuntu 18.04 LTS Gen2"
  default     = "18_04-lts-gen2"
}

variable "ubuntu_2004_sku" {
  type        = string
  description = "SKU for Ubuntu 20.04 LTS"
  default     = "20_04-lts"
}

variable "ubuntu_2004_gen2_sku" {
  type        = string
  description = "SKU for Ubuntu 20.04 LTS Gen2"
  default     = "20_04-lts-gen2"
}


#############################
## Application - Variables ##
#############################

# company name 
variable "company" {
  type        = string
  description = "This variable defines thecompany name used to build resources"
}

# application name 
variable "app_name" {
  type        = string
  description = "This variable defines the application name used to build resources"
}

# environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "north europe"
}



# # Create Service Principal to onboard Dome9
# variable "name" {
#   type        = string
#   default     = "cloudguard_api_0601"
#   description = "The name of the service principal."
# }
#variable "RedirectURI" {
#  type        = string
#  default     = "https://central.us1.cgn.portal.checkpoint.com"
#  description = "The name of the service principal."
#}
#variable "password" {
#  type        = string
#  default     = ""
#  description = "A password for the service principal."
#}
#variable "end_date" {
#  type        = string
#  default     = null
#  description = "The relative duration or RFC3339 date after which the password expire."
#}
#variable "years" {
#  type        = number
#  default     = null
#  description = "The number of years after which the password expire. Either this or `end_date` should be specified, but not both."
#}
#variable "role" {
#  type        = string
#  default     = ""
#  description = "The name of a role for the service principal."
#}
#variable "scopes" {
#  type        = list(string)
#  default     = []
#  description = "A list of scopes the role assignment applies to."
#}
#locals {
#  scopes = length(var.scopes) > 0 ? var.scopes : [data.azurerm_subscription.main.id]
#}