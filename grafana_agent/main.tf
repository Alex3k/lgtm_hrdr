terraform {
}

module "grafana_agent_a" {
  source = "./modules/grafana_agent"

  gcp_project_id=var.gcp_project_id

  gcp_svc_acc_file_path=var.gcp_svc_acc_file_path

  gcp_region=var.agent_a_gcp_region

  gke_cluster_name = var.agent_a_gke_cluster_name
  remote_write_url_a = var.remote_write_url_a
  remote_write_url_b = var.remote_write_url_b
  tenant_name = var.tenant_name
  oidc_client_id = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  oidc_token_url = var.oidc_token_url
}

module "grafana_agent_b" {
  source = "./modules/grafana_agent"

  gcp_project_id=var.gcp_project_id

  gcp_svc_acc_file_path=var.gcp_svc_acc_file_path

  gcp_region=var.agent_b_gcp_region

  gke_cluster_name = var.agent_b_gke_cluster_name
  remote_write_url_a = var.remote_write_url_a
  remote_write_url_b = var.remote_write_url_b
  tenant_name = var.tenant_name
  oidc_client_id = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  oidc_token_url = var.oidc_token_url
}