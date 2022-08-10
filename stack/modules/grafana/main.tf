terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "kubernetes"
    }
    helm = {
      source = "helm"
    }
  }
}

resource "random_string" "sql_database_postfix" {
  length  = 4
  special = false
  lower   = true
  numeric = false
  upper   = false
}

resource "google_sql_database_instance" "primary" {
  name                = "${var.mysql_database_name}-${random_string.sql_database_postfix.result}"
  region              = var.gcp_region
  database_version    = "MYSQL_8_0"
  deletion_protection = false

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    ip_configuration {
      private_network = "projects/${var.gcp_project_id}/global/networks/default"
      require_ssl     = false
      ipv4_enabled    = false
    }
  }
  depends_on = [
    random_string.sql_database_postfix
  ]
}

resource "random_password" "mysql_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "grafana_user" {
  name     = "grafana"
  instance = google_sql_database_instance.primary.name
  password = random_password.mysql_password.result
  host     = "%"

  depends_on = [
    google_sql_database_instance.primary,
    random_password.mysql_password
  ]
}

resource "google_sql_database" "grafana_db" {
  name     = "grafana"
  instance = google_sql_database_instance.primary.name
  depends_on = [
    google_sql_database_instance.primary,
    google_sql_user.grafana_user
  ]
}

resource "kubernetes_secret" "ge_secrets" {
  metadata {
    name = "ge-secrets"
  }
  data = {
    "license.jwt"    = file(var.ge_license_file)
    "admin_user"     = "admin"
    "admin_password" = var.admin_password
  }
}

resource "kubernetes_config_map" "plugin_config_map" {
  metadata {
    name = "grafana-plugin-configmap"
    labels = {
      grafana_plugin = ""
    }
  }

  data = {
    "grafana-metrics-enterprise-app.yaml" = templatefile("${path.module}/plugin_configmap.tftpl", {
      gem_token = var.gem_token
      gem_url   = var.gem_endpoint
      gel_token = var.gel_token
      gel_url   = var.gel_endpoint
    })
  }
}


resource "helm_release" "ge" {
  chart      = "grafana"
  name       = var.ge_deployment_name
  repository = "https://grafana.github.io/helm-charts"

  values = [
    templatefile("${path.module}/ge_overrides.tftpl", {
      ge_ip                       = var.ge_ip_address
      database_host               = "${google_sql_database_instance.primary.private_ip_address}:3306"
      database_user               = google_sql_user.grafana_user.name
      database_password           = google_sql_user.grafana_user.password
      oidc_client_id              = var.oidc_client_id
      oidc_client_secret          = var.oidc_client_secret
      oidc_auth_url               = var.oidc_auth_url
      oidc_token_url              = var.oidc_token_url
      oidc_userinfo_url           = var.oidc_userinfo_url
      grafana_role_attribute_path = var.grafana_role_attribute_path
      region                      = var.gcp_region
    })
  ]

  depends_on = [
    kubernetes_secret.ge_secrets,
    google_sql_database_instance.primary,
    google_sql_user.grafana_user,
    kubernetes_config_map.plugin_config_map
  ]
}
