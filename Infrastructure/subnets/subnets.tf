variable "project_id" {
}

variable "subnets" {
}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets
  name          = "${each.key}-${each.value.region}"
  project     = var.project_id
  region        = each.value.region
  network       = "${each.value.vpc_network}"
  ip_cidr_range = each.value.ip_cidr_range
}
