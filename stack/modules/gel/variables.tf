
variable "gcp_svc_acc_file_path" {
  type        = string
  description = "The path to a GCP service account JSON license file which has Editor permissions to the GCP project"
  nullable    = false
  validation {
    condition     = fileexists(var.gcp_svc_acc_file_path)
    error_message = "The file must exist"
  }
}

variable "gcp_gcs_bucket_name" {
  type        = string
  description = "The GCS bucket to create and store data in"
  nullable    = false
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy everything in"
  nullable    = false
}

variable "gke_cluster_name" {
  type        = string
  description = "The name of the GKE cluster GEl will be deployed to"
  nullable    = false
}

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "gel_cluster_name" {
  type        = string
  description = "The name of the GEL deployment that will be created as part of this process."
  nullable    = false
}

variable "gel_license_file" {
  type        = string
  description = "The file path to the GEL license file for zone A"
  nullable    = false

  validation {
    condition     = fileexists(var.gel_license_file)
    error_message = "The file must exist"
  }
}

variable "gel_admin_token_override" {
  type        = string
  description = "The override for the GEL tokengen to ensure we can use oidc"
  nullable    = false
}

variable "oidc_issuer_url" {
  type        = string
  description = "The issuer url for your oidc connection"
  nullable    = false
}

variable "oidc_access_policy_claim" {
  type        = string
  description = "The variable in the JWT that contains the access policies"
  nullable    = false
}