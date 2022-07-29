variable "gcp_project_id" {
  type        = string
  default     = "solutions-engineering-248511"
  description = "The GCP Project ID to use for this deployment"
  nullable    = false
}

variable "gcp_svc_acc_file_path" {
  type        = string
  description = "The path to a GCP service account JSON license file which has Editor permissions to the GCP project"
  nullable    = false
  validation {
    condition     = fileexists(var.gcp_svc_acc_file_path)
    error_message = "The file must exist"
  }
}

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
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

variable "authproxy_name_prefix" {
  type        = string
  description = "The prefix for authproxy. This will follow the format {prefix}-authproxy-{region}"
  nullable    = false
}

variable "oidc_access_policy_claim" {
  type        = string
  description = "The variable in the JWT that contains the access policies"
  nullable    = false
}



variable "gcp_region_a" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy one of the GEM instances to"
  nullable    = false
}

variable "gcp_service_account_name_a" {
  type        = string
  description = "The service account name that will be created as part of this process for gem/region a. Must be unique."
  nullable    = false
}

variable "gcp_gem_gke_cluster_name_a" {
  type        = string
  description = "The GKE cluster that will be created in region a. Must be unique."
  nullable    = false
}


variable "gem_a_license_file" {
  type        = string
  description = "The file path to the GEM license file for zone A"
  nullable    = false

  validation {
    condition     = fileexists(var.gem_a_license_file)
    error_message = "The file must exist"
  }
}

variable "gem_a_cluster_name" {
  type        = string
  description = "The name of the GEM A deployment that will be created as part of this process."
  nullable    = false
}


variable "gcp_gcs_bucket_prefix_a" {
  type        = string
  description = "This process creates three buckets with the postfix's tsdb, ruler and admit for the GEM A deployment. What should the prefix to these buckets be?"
  nullable    = false
}






variable "gcp_region_b" {
  type        = string
  default     = "europe-west2"
  description = "The region to deploy one of the GEM instances to"
  nullable    = false
}

variable "gcp_service_account_name_b" {
  type        = string
  description = "The service account name that will be created as part of this process for gem/region a. Must be unique."
  nullable    = false
}

variable "gcp_gem_gke_cluster_name_b" {
  type        = string
  description = "The GKE cluster that will be created in region b. Must be unique."
  nullable    = false
}


variable "gem_b_license_file" {
  type        = string
  description = "The file path to the GEM license file for zone B"
  nullable    = false

  validation {
    condition     = fileexists(var.gem_b_license_file)
    error_message = "The file must exist"
  }
}

variable "gem_b_cluster_name" {
  type        = string
  description = "The name of the GEM B deployment that will be created as part of this process."
  nullable    = false
}

variable "gcp_gcs_bucket_prefix_b" {
  type        = string
  description = "This process creates three buckets with the postfix's tsdb, ruler and admit for the GEM B deployment. What should the prefix to these buckets be?"
  nullable    = false
}

