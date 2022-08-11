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

output "gem_a_admin_endpoint" {
  value = module.gem_a.gateway_ip
}

output "gem_a_datasource_endpoint" {
  value = module.gem_a.datasource_endpoint
}

output "gel_a_endpoint" {
  value = module.gel_a.gateway_ip
}

output "gem_a_external_ip" {
  value = module.gem_a.gateway_ip
}

output "gem_b_admin_endpoint" {
  value = module.gem_b.admin_endpoint
}

output "gem_b_datasource_endpoint" {
  value = module.gem_b.datasource_endpoint
}

output "gel_b_endpoint" {
  value = module.gel_b.gateway_ip
}

output "gem_b_external_ip" {
  value = module.gem_b.gateway_ip
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

