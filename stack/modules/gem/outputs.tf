

output "gem_token_override" {
  value = var.gem_admin_token_override
}

output "gem_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gem"
}

output "gem_datasource_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gem/prometheus"
}

output "authproxy_external_ip" {
  value = "http://${google_compute_address.auth_proxy_ip.address}"
}