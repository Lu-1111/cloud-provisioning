variable "project_id" {
}

variable "firewall_rules" {
}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

#firewall rules

resource "google_compute_firewall" "rules" {
  for_each = var.firewall_rules
  project     = var.project_id
  name        = each.key
  network     = each.value.vpc_network
  description = "${each.value.description}"
  direction = each.value.direction
  disabled = each.value.disabled

  allow{
    protocol  = "${each.value.protocol}"
    ports     = each.value.ports
  }

  source_tags = toset(each.value.source_tags)
  target_tags = toset(each.value.target_tags)
}
