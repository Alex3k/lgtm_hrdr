// Common Output

output "gke_a_connection_command" {
  value = "gcloud container clusters get-credentials ${var.gcp_gke_cluster_name_a} --region ${var.gcp_region_a} --project ${var.gcp_project_id}"
}

output "gke_b_connection_command" {
  value = "gcloud container clusters get-credentials ${var.gcp_gke_cluster_name_b} --region ${var.gcp_region_b} --project ${var.gcp_project_id}"
}


// GEX Specific Outputs
output "gem_token_override" {
  value = var.gem_admin_token_override
}

output "gel_token_override" {
  value = var.gel_admin_token_override
}

output "gem_a_endpoint" {
  value = module.authproxy_a.gem_endpoint
}

output "gem_a_datasource_endpoint" {
  value = module.authproxy_a.gem_datasource_endpoint
}

output "gel_a_endpoint" {
  value = module.authproxy_a.gel_endpoint
}

output "gel_a_datasource_endpoint" {
  value = module.authproxy_a.gel_datasource_endpoint
}

output "authproxy_a_external_ip" {
  value = module.authproxy_a.external_ip
}

output "gem_b_endpoint" {
  value = module.authproxy_b.gem_endpoint
}

output "gem_b_datasource_endpoint" {
  value = module.authproxy_b.gem_datasource_endpoint
}

output "gel_b_endpoint" {
  value = module.authproxy_b.gel_endpoint
}

output "gel_b_datasource_endpoint" {
  value = module.authproxy_b.gel_datasource_endpoint
}

output "authproxy_b_external_ip" {
  value = module.authproxy_b.external_ip
}


// --------------------------------------------------------
// Grafana Enterprise Specific Outputs

output "grafana_username" {
  value     = "admin"
  sensitive = true
}

output "grafana_password" {
  value     = random_password.grafana_password.result
  sensitive = true
}

