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

resource "google_storage_bucket" "gem_storage_admin" {
  name          = "${var.gcp_gcs_bucket_prefix}-admin"
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "google_storage_bucket" "gem_storage_ruler" {
  name          = "${var.gcp_gcs_bucket_prefix}-ruler"
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "google_storage_bucket" "gem_storage_tsdb" {
  name          = "${var.gcp_gcs_bucket_prefix}-tsdb"
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "kubernetes_secret" "gem_secrets" {
  metadata {
    name = "gem-secrets"
  }
  data = {
    "gcp_service_account.json" = file(var.gcp_svc_acc_file_path)
    "gem_license.jwt"          = file(var.gem_license_file)
  }
}

resource "helm_release" "gem" {
  chart      = "mimir-distributed"
  name       = var.gem_cluster_name
  repository = "https://grafana.github.io/helm-charts"
  version = "3.1.0-weekly.199"

  values = [
    templatefile("${path.module}/gem_values.tftpl", {
      gem_cluster_name         = "${var.gem_cluster_name}"
      bucket_name_prefix       = "${var.gcp_gcs_bucket_prefix}"
      gem_tokengen_override    = var.gem_admin_token_override
      oidc_issuer_url          = var.oidc_issuer_url
      oidc_access_policy_claim = var.oidc_access_policy_claim
    })
  ]

  depends_on = [
    kubernetes_secret.gem_secrets,
    google_storage_bucket.gem_storage_admin,
    google_storage_bucket.gem_storage_ruler,
    google_storage_bucket.gem_storage_tsdb
  ]
}

resource "google_compute_address" "auth_proxy_ip" {
  name   = "${var.owner_name}-authproxy-${var.gcp_region}-ip"
  region = var.gcp_region
}

resource "helm_release" "auth_proxy" {
  chart = "./authproxy-helm-chart"
  name  = "${var.authproxy_name_prefix}-authproxy-${var.gcp_region}"

  values = [
    templatefile("${path.module}/authproxy_values.tftpl", {
      gem_gateway_url = "http://${var.gem_cluster_name}-mimir-gateway:8080"
      loadbalancer_ip = google_compute_address.auth_proxy_ip.address
    })
  ]
  depends_on = [
    google_compute_address.auth_proxy_ip
  ]
}

