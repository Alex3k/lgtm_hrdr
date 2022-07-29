terraform {
}

module "gem_a" {
  source = "./modules/gem"

  gcp_project_id           = var.gcp_project_id
  gcp_svc_acc_file_path    = var.gcp_svc_acc_file_path
  gcp_region               = var.gcp_region_a
  gcp_service_account_name = var.gcp_service_account_name_a
  gcp_gem_gke_cluster_name = var.gcp_gem_gke_cluster_name_a

  gcp_gcs_bucket_prefix = var.gcp_gcs_bucket_prefix_a
  owner_name            = var.owner_name
  gem_cluster_name      = var.gem_a_cluster_name
  gem_license_file      = var.gem_a_license_file
  gem_admin_token_override = var.gem_admin_token_override
  oidc_issuer_url = var.oidc_issuer_url
  oidc_access_policy_claim = var.oidc_access_policy_claim

  authproxy_name_prefix = var.authproxy_name_prefix
}

module "gem_b" {
  source = "./modules/gem"

  gcp_project_id           = var.gcp_project_id
  gcp_svc_acc_file_path    = var.gcp_svc_acc_file_path
  gcp_region               = var.gcp_region_b
  gcp_service_account_name = var.gcp_service_account_name_b
  gcp_gem_gke_cluster_name = var.gcp_gem_gke_cluster_name_b

  gcp_gcs_bucket_prefix = var.gcp_gcs_bucket_prefix_b
  owner_name            = var.owner_name
  gem_cluster_name      = var.gem_b_cluster_name
  gem_license_file      = var.gem_b_license_file
  gem_admin_token_override = var.gem_admin_token_override
  oidc_issuer_url = var.oidc_issuer_url
  oidc_access_policy_claim = var.oidc_access_policy_claim

  authproxy_name_prefix = var.authproxy_name_prefix
}


