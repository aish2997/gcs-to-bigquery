resource "google_workflows_workflow" "workflows" {
  for_each        = var.gcp_workflows
  name            = "wf-${each.value.workflow_name}"
  region          = var.main.region
  description     = each.value.description
  service_account = google_service_account.cloud_workflow_service_account.email
  source_contents = templatefile("${path.module}/${each.value.workflow_path}", {
    integration = each.value.integration
    project     = var.main.project
  })
  depends_on = [
    google_service_account.cloud_workflow_service_account
  ]
}


##### Service account for Cloud Workflow #####
resource "google_service_account" "cloud_workflow_service_account" {
  account_id   = "sa-cloud-workflow"
  display_name = "GCP Cloud Workflow Service Account"
  description  = ""
}

##### IAM Roles for Service account #####
resource "google_project_iam_member" "cloud_workflow_sa_roles" {
  for_each = toset([
    "roles/workflows.admin" # permissions used to invoke Workflows
  ])
  project = var.main.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloud_workflow_service_account.email}"
  depends_on = [
    google_service_account.cloud_workflow_service_account
  ]
}
