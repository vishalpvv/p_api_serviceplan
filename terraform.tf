terraform {
    backend "azurerm" {
        storage_account_name = "storage_account_name"
        container_name       = "tfstates"
        key                  = "p-api/p-api-regsub-web-app-service-plan01.tfstate"
        access_key           = "access_key"
        
    }
}