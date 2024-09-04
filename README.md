# Cloud Engineering Take-Home Assignment

## Objective

The goal of this assignment was to create and deploy a simple API to Google Cloud Platform (GCP) using Kubernetes (GKE) with Infrastructure as Code (IaC) exclusively through Terraform. Additionally, GitHub Actions was implemented for Continuous Deployment (CD). The API returns the current time in JSON format via a GET request.

## Repository Structure

- `Terraform/`: Contains all Terraform configurations for setting up GCP infrastructure and Kubernetes resources.
- `Terraform/policy/`: Contains OPA policy files for Terraform compliance.
- `node-project/`: Contains the source code for the API and Dockerfile.
- `.github/workflows/`: Contains GitHub Actions workflows for CI/CD.
- `README.md`: This file with setup and usage instructions.

## Prerequisites

Before running the setup, ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://www.terraform.io/downloads)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (gcloud CLI)
- [OPA](https://www.openpolicyagent.org/docs/latest/getting-started/) (for policy checks)


## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Faboya-korede/shortlet-task-gke.git
cd shortlet-task-gke
```

### 2. Build and Push Docker Image
- Navigate to the `node-project` directory and build the Docker image:

```bash
cd node-project
docker build -t gcr.io/YOUR_PROJECT_ID/current-time-api .
```

- Push the Docker image to Google Container Registry:

```bash
docker push gcr.io/YOUR_PROJECT_ID/shortlet-api
```

### 3. Configure Google Cloud SDK
- Authenticate with your Google Cloud account:

```bash
gcloud auth login
```

- Set the project ID:

```bash
gcloud config set project YOUR_PROJECT_ID
```

### 4. Initialize Terraform
- Navigate to the Terraform directory:

```bash
cd ../terraform
```

- Initialize Terraform

```bash
terraform init
```

### 5. Plan and Check Terraform Compliance with OPA
- Generate the Terraform plan and save it:

```bash
terraform plan -var-file=cred.tfvars -input=false -out="plan.tfplan"
```

- Convert the Terraform plan to JSON format:

```bash
terraform show -json plan.tfplan | grep -v "::debug::" | tail -n +2 > plan.json
```

- Run OPA to check if the Terraform configuration is compliant with the policies:

```bash
conftest test plan.json -o table --all-namespaces -p policy/
```


