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

resource "google_compute_address" "gel_gateway_ip" {
  name   = "${var.owner_name}-gel-${var.gcp_region}-ip"
  region = var.gcp_region
}

resource "google_storage_bucket" "gel_storage" {
  name          = var.gcp_gcs_bucket_name
  location      = var.gcp_region
  force_destroy = true
  labels = {
    owner = var.owner_name
  }
}

resource "kubernetes_secret" "gel_secrets" {
  metadata {
    name = "gel-secrets"
  }
  data = {
    "gcp_service_account.json" = file(var.gcp_svc_acc_file_path)
    "gel_license.jwt"          = file(var.gel_license_file)
  }
}

resource "helm_release" "gel" {
  chart      = "loki-simple-scalable"
  name       = var.gel_cluster_name
  repository = "https://grafana.github.io/helm-charts"
  version = "1.8.9"

  values = [
    templatefile("${path.module}/gel_values.tftpl", {
      gel_cluster_name         = var.gel_cluster_name
      bucket_name              = var.gcp_gcs_bucket_name
      gel_tokengen_override    = var.gel_admin_token_override
      oidc_issuer_url          = var.oidc_issuer_url
      oidc_access_policy_claim = var.oidc_access_policy_claim
      loadbalancer_ip          = google_compute_address.gel_gateway_ip.address
    })
  ]

  depends_on = [
    kubernetes_secret.gel_secrets,
    google_storage_bucket.gel_storage
  ]
}
