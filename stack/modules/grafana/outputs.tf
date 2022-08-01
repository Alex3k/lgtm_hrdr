output "grafana_ip" {
  value = "http://${var.ge_ip_address}:3000"
}

output "grafana_username" {
  value     = kubernetes_secret.ge_secrets.data.admin_user
  sensitive = true
}

output "grafana_password" {
  value     = random_password.ge_password.result
  sensitive = true
}