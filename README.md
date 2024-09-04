# Cloud Engineering Take-Home Assignment

## Objective

The goal of this assignment was to create and deploy a simple API to Google Cloud Platform (GCP) using Kubernetes (GKE) with Infrastructure as Code (IaC) exclusively through Terraform. Additionally, GitHub Actions was implemented for Continuous Deployment (CD). The API returns the current time in JSON format via a GET request.

## Repository Structure

- `terraform/`: Contains all Terraform configurations for setting up GCP infrastructure and Kubernetes resources.
- `api/`: Contains the source code for the API and Dockerfile.
- `.github/workflows/`: Contains GitHub Actions workflows for CI/CD.
- `README.md`: This file with setup and usage instructions.

## Prerequisites

Before running the setup, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://www.terraform.io/downloads)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (gcloud CLI)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Faboya-korede/shortlet-task-gke.git
cd shortlet-task-gke
```

### 2. Configure Google Cloud SDK
- Authenticate with your Google Cloud account:

