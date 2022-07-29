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

variable "grafana_a_gcp_region" {
  type        = string
  description = "The region to deploy everything in"
  nullable    = false
}

variable "grafana_a_identifier" {
  type        = string
  description = "What is the identifier for this deployment"
  nullable    = false
}

variable "grafana_b_gcp_region" {
  type        = string
  description = "The region to deploy everything in"
  nullable    = false
}

variable "grafana_b_identifier" {
  type        = string
  description = "What is the identifier for this deployment"
  nullable    = false
}