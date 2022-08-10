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

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy everything in"
  nullable    = false
}

variable "owner_name" {
  type        = string
  description = "Your name in lowercase and without spaces for GCP resource identification purposes."
  nullable    = false
}

variable "gke_cluster_name" {
  type        = string
  description = "The name of the GKE cluster GEM will be deployed to"
  nullable    = false
}

variable "ge_ip_address" {
  type        = string
  description = "The IP address that GE will be using which is outputted from the env_setup process"
  nullable    = false
}

variable "ge_license_file" {
  type        = string
  description = "The file path to the GE license file."
  nullable    = false

  validation {
    condition     = fileexists(var.ge_license_file)
    error_message = "The file must exist"
  }
}

variable "ge_deployment_name" {
  type        = string
  default     = "ge"
  description = "The Kubernetes Deployment name for GE"
  nullable    = false
}

variable "mysql_database_name" {
  type        = string
  description = "The name of the mysql database that will be created. Must be unique."
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

variable "oidc_auth_url" {
  type        = string
  description = "The Auth URL for the OIDC client"
  nullable    = false
}

variable "oidc_token_url" {
  type        = string
  description = "The Token URL for the OIDC client"
  nullable    = false
}

variable "oidc_userinfo_url" {
  type        = string
  description = "The User Info URL (also known as API URL) for the OIDC client"
  nullable    = false
}

variable "grafana_role_attribute_path" {
  type        = string
  description = "The role attribute path that maps the OIDC user roles to Grafana roles."
  nullable    = false
  sensitive   = false
}

variable "gem_token" {
  type        = string
  description = "The Access Token to configure and connect to GEM"
  nullable    = false
  sensitive   = true
}

variable "gem_endpoint" {
  type        = string
  description = "The endpoint to configure and connect to GEM"
  nullable    = false
  sensitive   = false
}


variable "gel_token" {
  type        = string
  description = "The Access Token to configure and connect to GEL"
  nullable    = false
  sensitive   = true
}

variable "gel_endpoint" {
  type        = string
  description = "The endpoint to configure and connect to GEL"
  nullable    = false
  sensitive   = false
}

variable "admin_password" {
  type        = string
  description = "The admin password for grafana"
  nullable    = false
  sensitive   = true
}

