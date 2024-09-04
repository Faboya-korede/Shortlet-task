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
- [OPA](https://www.openpolicyagent.org/docs/v0.11.0/get-started/) (for policy checks)
- [Confest](https://www.conftest.dev/install/) (Test your configuration files using Open Policy Agent)


## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Faboya-korede/Shortlet-task.git
cd shortlet-task
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

- Create cred.tfvars File

```bash
project_id       = "YOUR_PROJECT_ID"
region           = "YOUR_REGION"
cluster_location = "YOUR_CLUSTER_LOCATION" #us-eas1-b"
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
terraform show -json plan.tfplan   > plan.json
```

- Run OPA to check if the Terraform configuration is compliant with the policies:

```bash
conftest test plan.json -o table --all-namespaces -p policy/
```

### 6. Apply Terraform Configuration

- Apply the Terraform configuration to create the infrastructure and deploy the API:

```bash
terraform apply -var-file=cred.tfvars
```

### 7. Update DNS Record

### Get the External IP of the Load Balancer

1. **Go to the Google Cloud Console:**

   - Navigate to `Network Services > Load balancing`.

2. **Locate the Load Balancer associated with your GKE service:**

   - Find the Load Balancer that corresponds to your Google Kubernetes Engine (GKE) service.

3. **Copy the external IP address from the Load Balancer details:**

   - You will see an external IP address in the Load Balancer details section. Copy this IP address.

### Update DNS Records

1. **Update your DNS provider's records:**

   - Log in to your DNS provider's management console.
   - Find the DNS records section and update the relevant records (such as A or CNAME records) to point to the external IP address you copied.


### 8. Verify Deployment
- Check the deployed API endpoint to ensure it returns the current time.

```bash
curl <API_ENDPOINT_URL>
```

