locals {
  project = "interview-prj1"
  region  = "europe-west1"
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.project}"
  region = "${local.region}"
}
EOF
}

remote_state {
  backend = "gcs"
  config = {
    project  = local.project
    location = local.region
    bucket   = "${local.project}-${local.region}-statefiles"
    prefix   = "${path_relative_to_include()}/default.tfstate"

    gcs_bucket_labels = {
      owner = "terragrunt_test"
      name  = "terraform_state_storage"
    }
    skip_bucket_creation = false

  }
  #disable_dependency_optimization = true
}

terraform {

  extra_arguments "common_var" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    required_var_files = [
      # "${get_parent_terragrunt_dir()}/common.tfvars",
      "${get_parent_terragrunt_dir()}/variables.tfvars"
    ]
  }
}

  