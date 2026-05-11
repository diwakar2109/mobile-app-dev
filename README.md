# terraform-mobile-app (Repo1)

This repository contains a complete Terraform implementation for a mobile app “backend platform” on Azure.

It is organized into reusable modules under `modules/`, and a root entrypoint in `main.tf` that composes those modules.

## Resource Group Naming

Your desired pattern: `cp-mobile-$-$$$`

In this template, the resource group name is:

`cp-mobile-${var.environment}-${var.name_suffix}`

So you can map:
- `$`   -> `environment` (for example: `Dev`, `UAT`, `Prod`)
- `$$$` -> `name_suffix` (for example: `001`, `002`, ...)

## Architecture (Logical)

```text
 VNet (10.247.20.0/24)
 ├─ Subnet: applicationgateway-10.247.20.32/28   (App Gateway WAF v2)
 ├─ Subnet: application-10.247.20.64/27         (App Service VNet integration)
 └─ Subnet: database-10.247.20.96/27            (Private Endpoints)
 
 App Gateway (WAF)  --->  App Service (SPA host)
 
 Private Endpoints:
  - Azure SQL Server  ---> privatelink.database.windows.net
  - Azure Key Vault    ---> privatelink.vaultcore.azure.net
  - Azure Redis Cache  ---> privatelink.redis.cache.windows.net
 
 Observability:
  - Log Analytics + Application Insights
  - CPU metric alert (optional via `alert_emails`)
```

## Deployment Guide

### Prerequisites
- Terraform installed
- Azure credentials via OIDC in GitHub Actions (see workflow)
- Variables required by the root module:
  - `tenant_id`, `subscription_id`
  - `aad_admin_login`, `aad_admin_object_id` (Azure SQL AAD-only auth)

### GitHub Actions (OIDC)

Repo1 includes `.github/workflows/terraform-deploy.yml`.

You must set the following secrets in your GitHub repo:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

And ensure the GitHub principal has permission to create resources.

### Terragrunt call from Repo2 (Branches)

Repo2 can deploy this repo’s Terraform by configuring `terragrunt.hcl` to reference the Repo1 git URL (with `ref=` pointing at the desired branch/tag).

The provided Repo2 scaffolding (in the zip) shows how to structure `CP-mobile-Dev`, `CP-mobile-UAT`, and `CP-mobile-Prod`.

