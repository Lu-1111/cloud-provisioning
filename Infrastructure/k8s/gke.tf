variable "project_id" {
}
variable "region" {
}
variable "clusters" {
}
variable "node_pools"{
}


terraform {
  backend "gcs" {
}
  required_version = "= 1.6.0"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  for_each = var.clusters
  name     = each.key
  location = var.region
  project     = var.project_id
  min_master_version = each.value.master_version
  
  network = "${each.value.network}"
  subnetwork = each.value.subnetwork
  
  remove_default_node_pool = true
  initial_node_count       = 1


  release_channel {
    channel = each.value.master_release_channel
  }
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  lifecycle {
   create_before_destroy =  true 
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block =  each.value.cluster_ipv4_cidr_block
    services_ipv4_cidr_block =  each.value.services_ipv4_cidr_block
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "node_pools" {
  for_each = var.node_pools  
    name   = "${each.value.node_pool_machines_type}-${each.value.pool_suffix}"
    location   = var.region
    project     = var.project_id
    cluster    = each.value.cluster
    version = each.value.version
    node_count = each.value.gke_num_nodes
    node_locations = toset(each.value.node_locations)
  
    autoscaling { 
      min_node_count = each.value.min_node_count
      max_node_count = each.value.max_node_count
    }

    management {
      auto_repair = each.value.auto_repair
      auto_upgrade = each.value.auto_upgrade
    }

    upgrade_settings {
      max_unavailable = each.value.max_unavailable
      max_surge = each.value.max_surge
    }

    node_config {
      oauth_scopes = toset(each.value.oauth_scopes)

      labels = each.value.labels

      preemptible  = each.value.preemptible
      machine_type = each.value.node_pool_machines_type
      tags         = tolist("${each.value.tags}")
      metadata = {
        disable-legacy-endpoints = "true"
      }
    }
  depends_on = [
      google_container_cluster.primary
    ]
}
