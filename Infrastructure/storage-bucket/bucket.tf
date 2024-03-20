
variable "project_id" {
}
variable "region" {
}
variable "buckets" {
}


terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

# Create Storage Buckets

resource "google_storage_bucket" "storage_bucket" {
  for_each = var.buckets
    name          = "${var.project_id}-${each.key}"
    project = var.project_id
    location      = var.region
    force_destroy = each.value.force_destroy
    storage_class = each.value.storage_class
    public_access_prevention = each.value.public_access_prevention
}
# Commenting out until finding out why it is crashing
# resource "google_storage_bucket_acl" "set_bucket_acl" {
#   for_each = var.buckets
#     bucket = "${var.project_id}-${each.key}"
#     role_entity = toset(each.value.role_entity)
# }
