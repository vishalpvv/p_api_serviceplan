variable "environment_prefix"{
    type    = string
    default =  "dev"
}

variable "location_map" {
    type    = map
    default = {
        dev         = "westeurope"
        st          = "westeurope"
        sit         = "westeurope"
        sit2        = "westeurope"
        preprod-we  = "westeurope"
        prod-we     = "westeurope"
        preprod-ne  = "northeurope"
        prod-ne     = "northeurope"
    }
}

variable location_prefix_map {
    type    = map
    default = {
        westeurope  = "we"
        northeurope = "ne"
    }
}


variable "services_resource_group_map" {
    type    = map
    default = {
        dev         = "p-api-npd-rg-app-01"
        st          = "p-api-npd-rg-app-01"
        sit         = "p-api-npd-rg-app-01"
        sit2        = "p-api-sit-rg-app-01"
        preprod-we  = "p-api-ppd-rg-app-01"
        preprod-ne  = "p-api-ppd-rg-app-01"
        prod-we     = "p-api-prd-rg-app-01"
        prod-ne     = "p-api-prd-rg-app-01"
    }
}

variable "shared_resource_group_map" {
    type    = map
    default = {
        dev     = "shared-npd-rg-app-01"
        st      = "shared-npd-rg-app-01"
        sit     = "shared-npd-rg-app-01"
        sit2    = "shared-npd-rg-app-01"
        ppd     = "shared-ppd-rg-app-01"
        prd     = "shared-prd-rg-app-01"
    }
}

variable "prefix_map" {
    type    = map
    default = {
        dev = "dev"
        st  = "st"
        sit = "sit"
        sit2 = "sit"
        ppd = "preprod"
        prd = "prod"
    }
}

variable "service_bus_pass_name_prefix_map" {
    type    = map
    default = {
        dev  = "dev"
        st   = "dev"
        sit  = "sit"
        sit2 = "sit"
        ppd  = "preprod"
        prd  = "prod"
    }
}

variable "key_vault_name_map" {
    type    = map
    default = {
        dev = "dev-key-vault02"
        st  = "dev-key-vault02"
        sit = "sit-key-vault02"
        sit2 = "sit-key-vault02"
        ppd = "preprod-key-vault02"
        prd = "prod-key-vault01"
    }
}

variable "apim_ip_map" {
    type    = map
    default = {
        dev         = "11.111.171.121/32"
        st          = "11.111.171.121/32"
        sit         = "11.111.171.121/32"
        sit2        = "11.111.171.121/32"
        preprod-we  = "11.111.173.235/32"
        preprod-ne  = "11.111.56.222/32"
        prod-we     = "11.111.242.141/32"
        prod-ne     = "410.19.220.3/32"
    }
}

variable "vnet_name_map" {
    type    = map
    default = {
        dev        = "we-edge-dev-vn01"
        st         = "we-edge-dev-vn01"
        sit        = "we-edge-dev-vn01"
        sit2       = "we-edge-dev-vn01"
        preprod-we = "we-edge-ppd-vn-01"
        preprod-ne = "ne-edge-ppd-vn-01"
        prod-we    = "we-edge-prd-vn-01"
        prod-ne    = "ne-edge-prd-vn-011"
    }
}

variable "rmg_vnet_rg_name_map"{
    type    = map
    default = {
        dev        = "we-edge-dev-rgnet01"
        st         = "we-edge-dev-rgnet01"
        sit        = "we-edge-dev-rgnet01"
        sit2       = "we-edge-dev-rgnet01"
        preprod-we = "we-edge-ppd-rg-net01"
        preprod-ne = "ne-edge-ppd-rg-net01"
        prod-we    = "we-edge-prd-rg-net01"
        prod-ne    = "we-edge-prd-rg-net01"
    }
}

variable "rmg_subnet_name_map"{
    type    = map
    default = {
        dev        = "we-edge-dev-sn-vn01-apim"
        st         = "we-edge-dev-sn-vn01-apim"
        sit        = "we-edge-dev-sn-vn01-apim"
        sit2       = "we-edge-dev-sn-vn01-apim"
        preprod-we = "we-edge-ppd-sn-vn-01-apim"
        preprod-ne = "ne-edge-ppd-sn-vn-01-apim"
        prod-we    = "we-edge-prd-sn-vn-01-apim"
        prod-ne    = "ne-edge-prd-sn-vn-01-apim"
    }
}

variable "zone_reduntant_map" {
    type    = map
    default = {
        ppd     = true
        prd     = true
    }
}

variable "web_app_sku_map"{
    type = map
    default = {
        dev = {
            tier     = "Basic"
            size     = "B1"
            capacity = 1
        }

        st = {
            tier     = "Basic"
            size     = "B1"
            capacity = 1
        }

        sit = {
            tier     = "PremiumV3"
            size     = "P1v3"
            capacity =  1
        }

        ppd = {
            tier     = "PremiumV3"
            size     = "P2v3"
            capacity =  3
        }

        prd = {
            tier     = "PremiumV3"
            size     = "P2v3"
            capacity = 3
        }
    }
}


locals { 
    location                                   = lookup(var.location_map, terraform.workspace, "westeurope")
    location_prefix                            = lookup(var.location_prefix_map, local.location, "we")
    db_pass_name_prefix                        = lookup(var.prefix_map, var.environment_prefix, "feature")
    push_api_db_pass                           = sensitive(data.azurerm_key_vault_secret.eps_shared_db_push_api_password.value)
    web_app_sku                                = lookup(var.web_app_sku_map,var.environment_prefix,"${var.web_app_sku_map["dev"]}" )

    zone_redundant                             = lookup(var.zone_reduntant_map, var.environment_prefix, false)
   
}

data "azurerm_subscriptions" "available" {
    display_name_contains = "RMG Hosting Core"
}

data "azurerm_key_vault" "eps_shared_key_vault"{
    name                = local.key_vault_name
    resource_group_name = local.shared_resource_group_name
}
data "azurerm_key_vault_secret" "eps_shared_db_push_api_password" {
    name         = "${local.db_pass_name_prefix}-shared-db-p-api-dmluser-pass"
    key_vault_id = data.azurerm_key_vault.eps_shared_key_vault.id
}

data "azurerm_subnet" "apim_subnet" {
  provider             = azurerm.core_subscription
  name                 = local.rmg_subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.rmg_vnet_rg_name
}

