output "grafana_a_ip" {
  value = module.grafana_a.grafana_ip
}

output "grafana_a_username" {
  value     = module.grafana_a.grafana_username
  sensitive = true
}

output "grafana_a_password" {
  value     = module.grafana_a.grafana_password
  sensitive = true
}

output "grafana_b_ip" {
  value = module.grafana_b.grafana_ip
}

output "grafana_b_username" {
  value     = module.grafana_b.grafana_username
  sensitive = true
}

output "grafana_b_password" {
  value     = module.grafana_b.grafana_password
  sensitive = true
}