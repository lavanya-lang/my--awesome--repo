# Creates one GCE VM (gr-prod-web-01) in us-central1-a with a 10GB pd-balanced Debian 12 boot disk, along with a dedicated custom VPC network and subnetwork. Provider is configured for the given project and region; project_id is required (no default) and other settings default to the requested values.
# Generated Terraform code for GCP in us-central1

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 7.12.0"
    }
  }
}

variable "project_id" {
  description = "GCP Project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "GCP region for regional resources and provider configuration."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the compute instance."
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name of the GCE instance."
  type        = string
  default     = "gr-prod-web-01"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,62}$", var.instance_name))
    error_message = "instance_name must be 1-63 chars, lowercase, start with a letter, and contain only letters, numbers, and hyphens."
  }
}

variable "machine_type" {
  description = "Machine type for the GCE instance."
  type        = string
  default     = "e2-micro"
}

variable "boot_disk_image" {
  description = "Boot disk image in the form 'project/family' or a full self_link; e.g., 'debian-cloud/debian-12'."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 10
  validation {
    condition     = var.boot_disk_size_gb >= 10
    error_message = "boot_disk_size_gb must be at least 10 GB."
  }
}

variable "boot_disk_type" {
  description = "Boot disk type (e.g., pd-balanced, pd-standard, pd-ssd)."
  type        = string
  default     = "pd-balanced"
}

variable "allow_stopping_for_update" {
  description = "Whether Terraform is allowed to stop the instance to apply updates that require a restart."
  type        = bool
  default     = false
}

provider "google" {
  {{block_to_replace_cred}}region  = var.region
}

data "google_compute_image" "boot" {
  family  = "debian-12"
  project = "debian-cloud"
}

resource "google_compute_network" "main" {
  auto_create_subnetworks = false
  name                    = "gr-prod-net-01"
}

resource "google_compute_subnetwork" "main" {
  ip_cidr_range = "10.0.0.0/24"
  name          = "gr-prod-subnet-01"
  network       = google_compute_network.main.id
  region        = var.region
}

resource "google_compute_instance" "main" {
  allow_stopping_for_update = var.allow_stopping_for_update
  machine_type              = var.machine_type
  name                      = var.instance_name
  zone                      = var.zone

  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.boot.self_link
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.id
  }

  labels = {
    environment = "prod"
    managed_by  = "terraform"
    name        = "gr-prod-web-01"
  }
}

output "instance_name" {
  description = "Name of the created GCE instance."
  value       = google_compute_instance.main.name
}

output "instance_self_link" {
  description = "Self link of the created GCE instance."
  value       = google_compute_instance.main.self_link
}

output "instance_zone" {
  description = "Zone of the created GCE instance."
  value       = google_compute_instance.main.zone
}

output "network_name" {
  description = "Name of the VPC network created for the instance."
  value       = google_compute_network.main.name
}

output "subnetwork_name" {
  description = "Name of the subnetwork created for the instance."
  value       = google_compute_subnetwork.main.name
}