provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
    features {}
    alias                      = "core_subscription"
    subscription_id            = data.azurerm_subscriptions.available.subscriptions[0].subscription_id
    skip_provider_registration = true
}