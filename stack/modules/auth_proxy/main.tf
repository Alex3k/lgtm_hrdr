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

resource "google_compute_address" "auth_proxy_ip" {
  name   = "${var.owner_name}-authproxy-${var.gcp_region}-ip"
  region = var.gcp_region
}

resource "helm_release" "auth_proxy" {
  chart = "./authproxy-helm-chart"
  name  = "${var.authproxy_name_prefix}-authproxy-${var.gcp_region}"

  values = [
    templatefile("${path.module}/authproxy_values.tftpl", {
      gem_gateway_url = var.gem_cluster_gateway
      gel_gateway_url = var.gel_cluster_gateway
      loadbalancer_ip = google_compute_address.auth_proxy_ip.address
    })
  ]
  depends_on = [
    google_compute_address.auth_proxy_ip
  ]
}
