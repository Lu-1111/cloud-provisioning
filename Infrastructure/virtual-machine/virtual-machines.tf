variable "project_id" {
}
variable "region" {
}
variable "virtual_machines" {
}

terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

data "google_compute_default_service_account" "default" {
}

output "default_account" {
  value = data.google_compute_default_service_account.default.email
}

# COMPUTE INSTANCES
resource "google_compute_instance" "virtual-machine" {
  for_each = var.virtual_machines
    name         = each.key
    project      = var.project_id
    description = each.value.description
    zone         = "${var.region}-${each.value.zone}"
    machine_type = each.value.machine_type
    allow_stopping_for_update = true  
    
    labels = each.value.labels

    service_account {
      email  = data.google_compute_default_service_account.default.email
      scopes = ["cloud-platform"]
    }
    boot_disk {
      device_name = each.key
      initialize_params {
        image = each.value.boot_disk.image
        size = each.value.boot_disk.size
        type = each.value.boot_disk.type
      }
    }
    network_interface {
      access_config {
      network_tier = each.value.network_tier
      }
      subnetwork = each.value.subnetwork
      subnetwork_project = var.project_id
    }
    tags = each.value.network_tags
}
