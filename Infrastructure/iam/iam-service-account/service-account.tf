variable "project_id" {
}
variable "region" {
}
variable "service_accounts" {
}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

resource "google_service_account" "service_account" {
  for_each = var.service_accounts
    account_id   = each.key
    display_name = each.value.display_name
    description = each.value.description
    disabled = each.value.disabled
    project = var.project_id
}
