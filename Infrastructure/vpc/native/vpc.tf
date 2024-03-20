variable "project_id" {
}

variable "vpc_networks" {
}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}
# VPC
resource "google_compute_network" "vpc" {
  for_each = var.vpc_networks
    name                      = "${var.project_id}-${each.key}-${each.value.region}"
    project                   = var.project_id
    auto_create_subnetworks   = "${each.value.auto_create_subnetworks}"
    routing_mode              = "${each.value.routing_mode}"
    enable_ula_internal_ipv6  = "${each.value.enable_ula_internal_ipv6}"
}
