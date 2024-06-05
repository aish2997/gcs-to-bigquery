########## COMMON INPUTS ############
main = {
  project = "assessment-project-425415"
  region  = "europe-west1"
  env     = "dev"
}

project_id = "assessment-project-425415"
region     = "europe-west1"

########## GCP WORKFLOWS VARIABLES ############
cloud_scheduler = {
  cloud_scheduler_1 = {
    workflow_name = "wf-orchestration"
    region        = "europe-west1"
    name          = "workflow-job"
    cron          = "0 4 * * *"
    time_zone     = "Europe/Stockholm"
    deadline      = "320s"
    workflow_path = "../cloud_workflows/end-to-end.yaml"
  }
}

########## BIGQUERY DATASET INPUTS ############
bigquery_dataset = {
  stg = {
    dataset_id                 = "assessment_stg"
    dataset_friendly_name      = "assessment_stg"
    dataset_description        = ""
    delete_contents_on_destroy = "false"
    tier                       = "staging"
  },
  srv = {
    dataset_id                 = "assessment_srv"
    dataset_friendly_name      = "assessment_srv"
    dataset_description        = ""
    delete_contents_on_destroy = "false"
    tier                       = "serving"
  }
}

########## BIGQUERY TABLE INPUTS ############
bigquery_table = {
  orders_hst_v01 = {
    dataset_id          = "assessment_stg"
    table_id            = "orders_hst_v01"
    description         = ""
    deletion_protection = "false"
    schema              = "../schemas/staging/orders_schema.json"
    tier                = "staging"
    expiration_ms       = 0
  },
  inventory_hst_v01 = {
    dataset_id          = "assessment_stg"
    table_id            = "inventory_hst_v01"
    description         = ""
    deletion_protection = "false"
    schema              = "../schemas/staging/inventory_schema.json"
    tier                = "staging"
    expiration_ms       = 0
  },
  orders_srv = {
    dataset_id          = "assessment_srv"
    table_id            = "orders_srv"
    description         = ""
    deletion_protection = "false"
    schema              = "../schemas/serving/orders_schema.json"
    tier                = "serving"
    expiration_ms       = 0
  },
  inventory_srv = {
    dataset_id          = "assessment_srv"
    table_id            = "inventory_srv"
    description         = ""
    deletion_protection = "false"
    schema              = "../schemas/serving/inventory_schema.json"
    tier                = "serving"
    expiration_ms       = 0
  }
}

############ BUCKET INPUTS ##########
bucket = {
  bucket_1 = {
    name                     = "bucket-incoming-d"
    location                 = "europe-west1"
    storage_class            = "STANDARD"
    bucket_policy_only       = "true"
    force_destroy            = "true"
    versioning               = "true"
    public_access_prevention = "enforced"
  },
  bucket_2 = {
    name                     = "bucket-archive-d"
    location                 = "europe-west1"
    storage_class            = "STANDARD"
    bucket_policy_only       = "true"
    force_destroy            = "true"
    versioning               = "true"
    public_access_prevention = "enforced"
  }
}

########## GCP WORKFLOWS VARIABLES ############
gcp_workflows = {
  orders = {
    workflow_name = "orders"
    description   = ""
    workflow_path = "../cloud_workflows/processing_wf.yaml"
    integration   = "orders"
  },
  inventory = {
    workflow_name = "inventory"
    description   = ""
    workflow_path = "../cloud_workflows/processing_wf.yaml"
    integration   = "inventory"
  },
}

scheduled_query = {
  inventory_stg_to_srv = {
    name  = "sq-inventory_stg_to_srv"
    query = "../bq_logic/inventory_stg_to_srv.sql"
  },
  orders_stg_to_srv = {
    name  = "sq-orders_stg_to_srv"
    query = "../bq_logic/orders_stg_to_srv.sql"
  }
}