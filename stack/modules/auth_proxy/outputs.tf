
output "gem_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gem"
}

output "gem_datasource_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gem/prometheus"
}

output "external_ip" {
  value = "http://${google_compute_address.auth_proxy_ip.address}"
}

output "gel_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gel"
}

output "gel_datasource_endpoint" {
  value = "http://${google_compute_address.auth_proxy_ip.address}/gel/loki"
}

