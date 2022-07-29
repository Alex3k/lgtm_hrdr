
output "kubectl_cmd" {
  value = "gcloud container clusters get-credentials ${var.gcp_gem_gke_cluster_name} --region ${var.gcp_region} --project ${var.gcp_project_id}"
}

output "gem_token_override" {
  value = var.gem_admin_token_override
}

output "gem_endpoint" {
  value = "http://${helm_release.auth_proxy.id}/gem"
}

output "gem_datasource_endpoint" {
  value = "http://${helm_release.auth_proxy.id}/gem/prometheus"
}

output "authproxy_external_ip" {
  value = "http://${google_compute_address.auth_proxy_ip.address}"
}