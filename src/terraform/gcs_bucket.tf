resource "google_storage_bucket" "assessment" {
  for_each                    = var.bucket
  name                        = each.value.name
  project                     = var.main.project
  location                    = each.value.location
  storage_class               = each.value.storage_class
  force_destroy               = each.value.force_destroy
  public_access_prevention    = each.value.public_access_prevention
  uniform_bucket_level_access = each.value.bucket_policy_only
  versioning {
    enabled = each.value.versioning
  }
}