# payroll-challenge-infra

This is a repo to manage infrastructure for an application that manages employees and their dependents.

## Configuration

If forking, you'll need a Service Principal (SP) to run the GitHub Action. Instructions to configure this can be found [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret).

Additionally, the SP will need role management permissions in order to give the webapps the `AcrPull` permission.
