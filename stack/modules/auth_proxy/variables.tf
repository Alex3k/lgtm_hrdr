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

variable "authproxy_name_prefix" {
  type        = string
  description = "The prefix for authproxy. This will follow the format {prefix}-authproxy-{region}"
  nullable    = false
}

variable "gem_cluster_gateway" {
  type        = string
  description = "The name of the GEM deployment that the AuthProxy points to"
  nullable    = false
}

variable "gel_cluster_gateway" {
  type        = string
  description = "The name of the GEL deployment that the AuthProxy points to"
  nullable    = false
}
