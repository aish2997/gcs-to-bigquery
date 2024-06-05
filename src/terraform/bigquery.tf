# BQ Dataset creation and configuration
resource "google_bigquery_dataset" "bigquery_dataset" {
  for_each                   = var.bigquery_dataset
  dataset_id                 = each.value.dataset_id
  friendly_name              = each.value.dataset_friendly_name
  description                = each.value.dataset_description
  project                    = var.main.project
  location                   = var.main.region
  delete_contents_on_destroy = each.value.delete_contents_on_destroy

  labels = {
    env  = var.main.env
    tier = each.value.tier
  }
}

# BQ Table creation and configuration
resource "google_bigquery_table" "bigquery_table" {
  for_each            = var.bigquery_table
  dataset_id          = each.value.dataset_id
  table_id            = each.value.table_id
  description         = each.value.description
  deletion_protection = each.value.deletion_protection
  project             = var.main.project
  schema              = file("${each.value.schema}")
  expiration_time     = null
  labels = {
    env  = var.main.env
    tier = each.value.tier
  }

  depends_on = [
    google_bigquery_dataset.bigquery_dataset
  ]
}