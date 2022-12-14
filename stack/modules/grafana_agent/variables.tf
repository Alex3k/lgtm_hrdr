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
}

variable "oidc_client_id" {
  type        = string
  description = "The OIDC client ID"
  nullable    = false
  sensitive   = true
}

variable "oidc_client_secret" {
  type        = string
  description = "The secret for the OIDC client"
  nullable    = false
  sensitive   = true
}

variable "oidc_token_url" {
  type        = string
  description = "The Token URL for the OIDC client"
  nullable    = false
}

variable "gcp_region" {
  type        = string
  description = "The region to deploy everything in"
  nullable    = false
}

variable "gke_cluster_name" {
  type        = string
  description = "The GKE cluster that you want to connect to and deploy grafana agent into."
  nullable    = false
}

variable "gem_remote_write_url_a" {
  type        = string
  description = "The URL that should be used for region a"
  nullable    = false
}

variable "gem_remote_write_url_b" {
  type        = string
  description = "The URL that should be used for region b"
  nullable    = false
}

variable "gel_a_endpoint" {
  type        = string
  description = "The endpoint to write to GEL in region A"
  nullable    = false
}

variable "gel_b_endpoint" {
  type        = string
  description = "The endpoint to write to GEL in region B"
  nullable    = false
}

variable "tenant_name" {
  type        = string
  description = "The tenant to send data to"
  nullable    = false
}