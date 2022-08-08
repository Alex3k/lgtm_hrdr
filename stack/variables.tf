// Common Variables

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


variable "gcp_region_a" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy one of the GEM instances to"
  nullable    = false
}


variable "gcp_region_b" {
  type        = string
  default     = "europe-west2"
  description = "The region to deploy one of the GEM instances to"
  nullable    = false
}

variable "gcp_gke_cluster_name_a" {
  type        = string
  description = "The GKE cluster to create for Region A into. Must not exist."
  nullable    = false
}

variable "gcp_gke_cluster_name_b" {
  type        = string
  description = "The GKE cluster to create for Region B into. Must not exist."
  nullable    = false
}


// --------------------------------------------------------
// GEM Specific Variables
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

variable "oidc_issuer_url" {
  type        = string
  description = "The issuer url for your oidc connection"
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


variable "grafana_role_attribute_path" {
  type        = string
  description = "The role attribute path that maps the OIDC user roles to Grafana roles."
  nullable    = false
  sensitive   = false
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

// --------------------------------------------------------
// Grafana Enterprise Variables

variable "grafana_global_ip_address" {
  type        = string
  description = "The IP address that GE will be using which is outputted from the env_setup process"
  nullable    = false
}

variable "grafana_global_license_file" {
  type        = string
  description = "The file path to the GE license file."
  nullable    = false

  validation {
    condition     = fileexists(var.grafana_global_license_file)
    error_message = "The file must exist"
  }
}

variable "grafana_a_gcp_region" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy everything in"
  nullable    = false
}

variable "grafana_a_deployment_name" {
  type        = string
  default     = "ge"
  description = "The Kubernetes Deployment name for GE"
  nullable    = false
}

variable "grafana_a_mysql_database_name" {
  type        = string
  description = "The name of the mysql database that will be created. Must be unique."
  nullable    = false
}

variable "grafana_b_gcp_region" {
  type        = string
  default     = "us-central1"
  description = "The region to deploy everything in"
  nullable    = false
}


variable "grafana_b_deployment_name" {
  type        = string
  default     = "ge"
  description = "The Kubernetes Deployment name for GE"
  nullable    = false
}

variable "grafana_b_mysql_database_name" {
  type        = string
  description = "The name of the mysql database that will be created. Must be unique."
  nullable    = false
}


// --------------------------------------------------------
// Grafana Agent Variables
variable "data_shipper_oidc_client_id" {
  type        = string
  description = "The OIDC client ID required for Data Shippers to authenticate with OIDC"
  nullable    = false
  sensitive   = true
}

variable "data_shipper_oidc_client_secret" {
  type        = string
  description = "The secret for the OIDC client required for Data Shippers to authenticate with OIDC"
  nullable    = false
  sensitive   = true
}

variable "data_shipper_oidc_token_url" {
  type        = string
  description = "The Token URL for the OIDC client required for Data Shippers to authenticate with OIDC"
  nullable    = false
}

variable "data_shipper_tenant_name" {
  type        = string
  description = "The tenant to send data to"
  nullable    = false
}


