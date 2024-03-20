variable "project_id" {

}
variable "registry" {
}
# variable "location" {
# }
terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

resource "google_container_registry" "registry" {
    for_each    = var.registry
        project     = var.project_id

}


