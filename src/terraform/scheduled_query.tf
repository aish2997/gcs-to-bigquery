resource "google_bigquery_data_transfer_config" "scheduled_query_config" {
  for_each             = var.scheduled_query
  display_name         = each.value.name
  project              = var.main.project
  location             = var.main.region
  data_source_id       = "scheduled_query"
  service_account_name = google_service_account.scheduled_query_service_account.email
  schedule_options {
    disable_auto_scheduling = true
  }
  params = {
    query = templatefile("${each.value.query}", { project_id = var.main.project })
  }
  depends_on = [
    google_service_account.scheduled_query_service_account
  ]
}

##### Service account for Scheduled Query #####
resource "google_service_account" "scheduled_query_service_account" {
  account_id   = "sa-scheduled-query"
  display_name = "GCP Scheduled Query Service Account"
  description  = ""
}

##### IAM Roles for Service account #####
resource "google_project_iam_member" "scheduled_query_sa_roles" {
  for_each = toset([
    "roles/bigquery.admin" # permissions used to invoke Workflows
  ])
  project = var.main.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.scheduled_query_service_account.email}"
  depends_on = [
    google_service_account.scheduled_query_service_account
  ]
}
