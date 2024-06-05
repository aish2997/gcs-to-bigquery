########## COMMON VARIABLES ############
variable "main" {
  type = object({
    project = string
    region  = string
    env     = string
  })
}
variable "project_id" {
  type        = string
  description = "ID of the project"
}

variable "region" {
  type        = string
  description = "GCP region for the network"
  default     = "europe-west1"
}
variable "cloud_scheduler" {
  type = map(object({
    workflow_name = string
    region        = string
    name          = string
    cron          = string
    time_zone     = string
    deadline      = string
    workflow_path = string
  }))
}

########## BIGQUERY DATASET ############
variable "bigquery_dataset" {
  type = map(object({
    dataset_id                 = string
    dataset_friendly_name      = string
    dataset_description        = string
    delete_contents_on_destroy = bool
    tier                       = string
  }))
}

########## BIGQUERY TABLE ############
variable "bigquery_table" {
  type = map(object({
    dataset_id          = string
    table_id            = string
    description         = string
    tier                = string
    deletion_protection = bool
    schema              = string
    expiration_ms       = string
  }))
}

##### BUCKET VARIABLES ########
variable "bucket" {
  type = map(object({
    name                     = string
    location                 = string
    storage_class            = string
    versioning               = bool
    force_destroy            = bool
    public_access_prevention = string
    bucket_policy_only       = bool
  }))
}

########## GCP WORKFLOWS VARIABLES ############
variable "gcp_workflows" {
  type = map(object({
    workflow_name = string
    description   = string
    workflow_path = string
    integration   = string
  }))
}

variable "scheduled_query" {
  type = map(object({
    name  = string
    query = string
  }))
}