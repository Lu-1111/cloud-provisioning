variable "project_id" {
  description = "Anak-Neto-DR"
}
variable "region" {
  description = "europe-west1-b"
}
#variable "projects" {}
variable "user_email" {}
variable "group_email" {}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.4"

  projects = [ "${var.project_id}"] #"${var.projects}"]

  bindings = {
    "roles/storage.admin" = [
      #"group:test_sa_group@lnescidev.com",
      "user:${var.user_email}",
    ]
  }
}