variable "gcp_svc_acc_file_path" {
  type        = string
  description = "The path to a GCP service account JSON license file which has Editor permissions to the GCP project"
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
  description = "The name of the GKE cluster GEM will be deployed to"
  nullable    = false
}

variable "gcp_gcs_bucket_prefix" {
  type        = string
  description = "This process created three buckets with the postfix's tsdb, ruler and admit. What should the prefix to these buckets be?"
  nullable    = false
}

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "gem_cluster_name" {
  type        = string
  description = "The name of the GEM deployment that will be created as part of this process."
  nullable    = false
}

variable "gem_license_file" {
  type        = string
  description = "The file path to the GEM license file for zone A"
  nullable    = false

}

variable "oidc_issuer_url" {
  type        = string
  description = "The issuer url for your oidc connection"
  nullable    = false
}

variable "gem_admin_token_override" {
  type        = string
  description = "The override for the GEM tokengen to ensure we can use oidc"
  nullable    = false
}
variable "oidc_access_policy_claim" {
  type        = string
  description = "The variable in the JWT that contains the access policies"
  nullable    = false
}

variable "authproxy_name_prefix" {
  type        = string
  description = "The prefix for authproxy. This will follow the format {prefix}-authproxy-{region}"
  nullable    = false
}
