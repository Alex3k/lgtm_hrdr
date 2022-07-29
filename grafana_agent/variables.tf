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

variable "agent_a_gcp_region" {
  type        = string
  description = "The region to deploy everything in"
  nullable    = false
}

variable "agent_b_gcp_region" {
  type        = string
  description = "The region to deploy everything in"
  nullable    = false
}

variable "agent_a_gke_cluster_name" {
  type        = string
  description = "The GKE cluster that you want to connect to and deploy grafana agent into."
  nullable    = false
}

variable "agent_b_gke_cluster_name" {
  type        = string
  description = "The GKE cluster that you want to connect to and deploy grafana agent into."
  nullable    = false
}

variable "remote_write_url_a" {
  type = string
  description = "The URL that should be used for region a"
  nullable    = false
}

variable "remote_write_url_b" {
  type = string
  description = "The URL that should be used for region b"
  nullable    = false
}

variable "tenant_name" {
  type = string
  description = "The tenant to send data to"
  nullable    = false
}