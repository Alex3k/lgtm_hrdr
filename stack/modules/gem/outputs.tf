output "gem_token_override" {
  value = var.gem_admin_token_override
}

output "gateway_ip" {
  value = google_compute_address.auth_proxy_ip.address
}

output "admin_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gem"
}

output "datasource_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gem/prometheus"
}

output "ingest_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/prometheus"
}
