locals {
  # Load the data from main terragrunt.hcl
  common = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}
##use the backend config from the root dir
include "root" {
  path = find_in_parent_folders()
}

terraform {

  extra_arguments "common_var" {
    commands  = get_terraform_commands_that_need_vars()
    arguments = ["-var-file=${get_terragrunt_dir()}/vars/${local.common.remote_state.config.project}-${local.common.remote_state.config.location}/custom-role.tfvars"]
    required_var_files = [
      "${get_parent_terragrunt_dir()}/variables.tfvars"
    ]
  }
}