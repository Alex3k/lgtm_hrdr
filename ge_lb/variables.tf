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

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "grafana_global_ip_address" {
  type        = string
  description = "The IP address that GE will be using which is outputted from the env_setup process"
  nullable    = false
}

variable "grafana_a_service_name" {
  type        = string
  description = "The service name for grafana deployed in region a"
  nullable    = false
}

variable "grafana_b_service_name" {
  type        = string
  description = "The service name for grafana deployed in region b"
  nullable    = false
}
