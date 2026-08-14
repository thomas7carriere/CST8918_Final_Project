# Final Project: Terraform, Azure AKS, and GitHub Actions

## CST8918 - DevOps: Infrastructure as Code 
### Professor: Robert McKenney

## Overview
This project uses Terraform to deploy the Remix Weather Application to Azure
Kubernetes Service (AKS). It provisions the base network, AKS clusters for test
and production, an Azure Container Registry, and Azure Cache for Redis. Terraform
state is stored remotely in Azure Blob Storage, and GitHub Actions automates the
static analysis, plan, and apply workflows using Azure federated identity (OIDC).

## Team Members
- Thomas de Haan Carriere - [thomas7carriere](https://github.com/thomas7carriere)
- Anoop Sidhu - [ansid0109](https://github.com/ansid0109)
- Ilyas Zazai - [Ilyzazai](https://github.com/Ilyzazai)

## Structure
- `infra/backend` - remote state bootstrap (Azure Blob Storage)
- `infra/network` - resource group, virtual network, subnets
- `infra/platform` - AKS clusters, ACR, Redis
- `infra/app` - Kubernetes deployment and service for the weather app
- `modules/` - reusable Terraform modules
- `app/` - Remix Weather Application

## CI/CD
- Static analysis (fmt, validate, tfsec) runs on push to any branch
- tflint and terraform plan run on pull requests to main
- terraform apply runs on merge to main
- Application image build and deploy run when app code changes

## Running the Project
The backend is bootstrapped once from `infra/backend`. All other Terraform roots
use the shared azurerm backend. Changes are made through pull requests to main,
which must pass status checks and receive one approving review before merging.

## CI Status
<!-- Screenshot of successful GitHub Actions workflows goes here before submission -->
