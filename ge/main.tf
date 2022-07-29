terraform {
}

module "grafana_a" {
  source = "./modules/grafana"

  gcp_project_id=var.gcp_project_id

  gcp_svc_acc_file_path=var.gcp_svc_acc_file_path

  owner_name=var.owner_name

  gcp_region=var.grafana_a_gcp_region

  ge_deployment_name= var.grafana_a_deployment_name

  gke_cluster_name=var.grafana_a_gke_cluster_name

  ge_ip_address = var.grafana_a_ip_address

  ge_license_file = var.grafana_a_license_file

  mysql_database_name = var.grafana_a_mysql_database_name

  oidc_client_id = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  oidc_auth_url = var.oidc_auth_url
  oidc_token_url = var.oidc_token_url
  oidc_userinfo_url = var.oidc_userinfo_url
  grafana_role_attribute_path = var.grafana_role_attribute_path
}


module "grafana_b" {
  source = "./modules/grafana"

  gcp_project_id=var.gcp_project_id

  gcp_svc_acc_file_path=var.gcp_svc_acc_file_path

  owner_name=var.owner_name

  gcp_region=var.grafana_b_gcp_region

  ge_deployment_name= var.grafana_b_deployment_name

  gke_cluster_name=var.grafana_b_gke_cluster_name

  ge_ip_address = var.grafana_b_ip_address

  ge_license_file = var.grafana_b_license_file

  mysql_database_name = var.grafana_b_mysql_database_name

  oidc_client_id = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  oidc_auth_url = var.oidc_auth_url
  oidc_token_url = var.oidc_token_url
  oidc_userinfo_url = var.oidc_userinfo_url
  grafana_role_attribute_path = var.grafana_role_attribute_path

}
