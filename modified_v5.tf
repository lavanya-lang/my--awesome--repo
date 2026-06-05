# Fixes validation error by removing the unsupported/invalid bucket encryption block and leaving a minimal Google Cloud Storage bucket configuration with required arguments.
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

variable "bucket_location" {
  description = "GCS bucket location (region or multi-region)."
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name of the GCS bucket (must be globally unique)."
  type        = string
  default     = "test-bucket"

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters."
  }
}

variable "project_id" {
  description = "GCP Project ID (injected/provided via selected credentials)."
  type        = string
}

variable "storage_class" {
  description = "GCS storage class."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "storage_class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

provider "google" {
  {{block_to_replace_cred}}
}

resource "google_storage_bucket" "this" {
  location                    = var.bucket_location
  name                        = var.bucket_name
  project                     = var.project_id
  storage_class               = var.storage_class
  uniform_bucket_level_access = true
}

output "bucket_name" {
  description = "Name of the created GCS bucket."
  value       = google_storage_bucket.this.name
}

output "bucket_self_link" {
  description = "Self link of the created GCS bucket."
  value       = google_storage_bucket.this.self_link
}