// Common Output

output "gke_a_connection_command" {
  value = "gcloud container clusters get-credentials ${var.gcp_gke_cluster_name_a} --region ${var.gcp_region_a} --project ${var.gcp_project_id}"
}

output "gke_b_connection_command" {
  value = "gcloud container clusters get-credentials ${var.gcp_gke_cluster_name_b} --region ${var.gcp_region_b} --project ${var.gcp_project_id}"
}


// GEM Specific Outputs
output "gem_token_override" {
  value = var.gem_admin_token_override
}

output "gem_a_endpoint" {
  value = module.gem_a.gem_endpoint
}

output "gem_a_datasource_endpoint" {
  value = module.gem_a.gem_datasource_endpoint
}

output "gem_b_endpoint" {
  value = module.gem_b.gem_endpoint
}

output "gem_b_datasource_endpoint" {
  value = module.gem_b.gem_datasource_endpoint
}

output "authproxy_a_external_ip" {
  value = module.gem_a.authproxy_external_ip
}

output "authproxy_b_external_ip" {
  value = module.gem_b.authproxy_external_ip
}


// --------------------------------------------------------
// Grafana Enterprise Specific Outputs

output "global_grafana_ip" {
  value = module.grafana_global_loadbalancer.global_grafana_ip
}

output "grafana_username" {
  value     = "admin"
  sensitive = true
}

output "grafana_password" {
  value     = random_password.grafana_password.result
  sensitive = true
}

