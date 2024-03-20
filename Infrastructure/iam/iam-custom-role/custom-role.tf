variable "project_id" {
}
variable "region" {
}
variable "custom_roles" {
}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

resource "google_project_iam_custom_role" "custom_role" {
  for_each = var.custom_roles
    role_id     = each.key
    title       = each.value.title
    description = each.value.description
    project = var.project_id
    stage = each.value.stage
    permissions = toset(each.value.permissions)
}

# The role must be referred to like: [projects|organizations]/{parent-name}/roles/{role-name}

resource "google_project_iam_binding" "project" {
  for_each = var.custom_roles
    role    = "projects/${var.project_id}/roles/${each.key}"
    project = var.project_id
    members = toset(each.value.members)
  depends_on = [
      google_project_iam_custom_role.custom_role
    ]
}
