# Ingest Data from GCS to BigQuery

## Steps to Follow

1. **Update the GCP Project ID**
   - Modify the GCP project ID in the `_dev.tfvars` file.

2. **Create a Project Service Account**
   - Create a service account in your GCP project.
   - Export the service account keys and place the key file in the root directory of the repository.
   - Provide the path to this key file in the `main.tf` file.

3. **Run the Following Commands**

   ```bash
   cd src/terraform
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan -var-file=_dev.tfvars -var {your_project_id} -out=plan.tfplan
   terraform apply plan.tfplan
   ```

## Detailed Steps

### 1. Update the GCP Project ID

Open the `_dev.tfvars` file located in the root directory and replace the placeholder project ID with your actual GCP project ID.

### 2. Create a Project Service Account

- **Create the Service Account:**
  - In the Google Cloud Console, navigate to the IAM & Admin section.
  - Create a new service account and grant it the necessary permissions.

- **Export the Service Account Key:**
  - Download the JSON key file for the service account.
  - Place this key file in the root directory of your repository.

- **Update `main.tf` with the Key Path:**
  - Open the `main.tf` file.
  - Add or update the path to the service account key file.

    ```hcl
    provider "google" {
      credentials = file("<path-to-your-service-account-key>.json")
      project     = var.project_id
      region      = var.region
    }
    ```

### 3. Initialize Terraform

Navigate to the `src/terraform` directory:

```bash
cd src/terraform
```

Initialize the Terraform working directory:

```bash
terraform init
```

### 4. Format Terraform Configuration Files

Check the formatting of the Terraform files:

```bash
terraform fmt -check
```

### 5. Validate Terraform Configuration

Validate the Terraform configuration to ensure it is syntactically valid and internally consistent:

```bash
terraform validate
```

### 6. Plan the Terraform Deployment

Create an execution plan, specifying the `_dev.tfvars` file and your project ID:

```bash
terraform plan -var-file=_dev.tfvars -var {your_project_id} -out=plan.tfplan
```

### 7. Apply the Terraform Plan

Apply the generated plan to deploy the resources:

```bash
terraform apply plan.tfplan
```

---

Ensure you have the necessary permissions and credentials configured to interact with your GCP project.