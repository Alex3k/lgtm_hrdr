output "grafana_global_ip_address" {
  value = google_compute_global_address.grafana_global_ip.address
}
