terraform {
}

module "grafana_a" {
  source = "./modules/infra"

  gcp_project_id=var.gcp_project_id

  gcp_svc_acc_file_path=var.gcp_svc_acc_file_path

  owner_name=var.owner_name

  gcp_region=var.grafana_a_gcp_region
  identifier = var.grafana_a_identifier
}

module "grafana_b" {
  source = "./modules/infra"

  gcp_project_id=var.gcp_project_id

  gcp_svc_acc_file_path=var.gcp_svc_acc_file_path

  owner_name=var.owner_name

  gcp_region=var.grafana_b_gcp_region
  identifier = var.grafana_b_identifier
}



