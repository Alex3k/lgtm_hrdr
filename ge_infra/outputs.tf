output "grafana_a_ip_address" {
  value = module.grafana_a.ge_ip_address
}

output "grafana_b_ip_address" {
  value = module.grafana_b.ge_ip_address
}
