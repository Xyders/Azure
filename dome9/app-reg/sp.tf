# For terraform guide:
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password

terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}
# add for AD configuration for Dome9
provider "azuread" {}



# create service principal used for onboarding Dome9
data "azurerm_client_config" "main" {}
data "azurerm_subscription" "main" {}
data "azuread_client_config" "current" {}
data "azuread_application_published_app_ids" "well_known" {}

#resource "azuread_service_principal" "msgraph" {
#  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
#  use_existing = true
#}


# Create an application
resource "azuread_application" "main" {
  display_name               = var.sp_name
  #available_to_other_tenants = false
  #redirect_uris              = [var.RedirectURI]
  #type                       = "webapp/api"
  owners                     = [data.azuread_client_config.current.object_id]
  web {
    #homepage_url  = var.homepage_url
    #logout_url    = var.logout_url
    redirect_uris = [var.RedirectURI]
    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"  # MS Graph app id.

    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61" # Directory.Read.All id.
      type = "Role"
    }

    resource_access {
      id   = "230c1aed-a721-4c5d-9cb4-a90514e508ef" # Reports.Read.All id.
      type = "Role"
    }
  }
}
# Create a service principal
resource "azuread_service_principal" "main" {
  application_id                = azuread_application.main.application_id
  app_role_assignment_required  = false
  owners                        = [data.azuread_client_config.current.object_id]
}
resource "time_rotating" "main" {
  rotation_rfc3339 = var.end_date
  rotation_years   = var.years
  triggers = {
    end_date = var.end_date
    years    = var.years
  }
}
resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.object_id
  rotate_when_changed = {
    rotation = time_rotating.main.id
  }
}
#resource "random_password" "main" {
#  count  = var.password == "" ? 1 : 0
#  length = 32
#  keepers = {
#    rfc3339 = time_rotating.main.id
#  }
#}
#resource "azuread_service_principal_password" "main" {
#  count                = var.password != null ? 1 : 0
#  service_principal_id = azuread_service_principal.main.id
#  value                = coalesce(var.password, random_password.main[0].result)
#  end_date             = time_rotating.main.rotation_rfc3339
#}

 
# Assign a Network Contributor role
resource "azurerm_role_assignment" "main" {
  #scope                = data.azurerm_subscription.main.id
  scope                = local.scopes[count.index]
  role_definition_name = var.role
  principal_id         = azuread_service_principal.main.object_id
  count                = var.role != "" ? length(local.scopes) : 0
  #role_definition_id   = format("%s%s", data.azurerm_subscription.main.id, data.azurerm_role_definition.main[0].id)
}