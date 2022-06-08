

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