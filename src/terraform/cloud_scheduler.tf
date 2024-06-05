module "cloud_workflow" {
  for_each = var.cloud_scheduler

  project_id            = var.main.project
  source                = "GoogleCloudPlatform/cloud-workflows/google"
  workflow_name         = each.value.workflow_name
  region                = each.value.region
  service_account_email = google_service_account.cloud_workflow_service_account.email

  workflow_trigger = {
    cloud_scheduler = {
      name                  = each.value.name
      cron                  = each.value.cron
      time_zone             = each.value.time_zone
      deadline              = each.value.deadline
      service_account_email = google_service_account.cloud_workflow_service_account.email
    }
  }
  workflow_source = file(each.value.workflow_path)
  depends_on = [
    google_service_account.cloud_scheduler_service_account
  ]
}

##### Service account for Cloud Scheduler #####
resource "google_service_account" "cloud_scheduler_service_account" {
  account_id   = "sa-cloud-scheduler"
  display_name = "GCP Cloud Scheduledcheduler Service Account"
  description  = ""
}

##### IAM Roles for Service account #####
resource "google_project_iam_member" "cloud_scheduler_sa_roles" {
  for_each = toset([
    "roles/cloudscheduler.admin" # permissions used to invoke Workflows
  ])
  project = var.main.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloud_scheduler_service_account.email}"
  depends_on = [
    google_service_account.cloud_scheduler_service_account
  ]
}