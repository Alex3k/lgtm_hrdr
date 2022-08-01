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

resource "helm_release" "agent" {
  chart = "./agent-helm-chart"
  name  = "grafana-agent"

  values = [
    templatefile("${path.module}/agent_overrides.yaml", {
      cluster_label_value = var.gcp_region
      remote_write_url_a  = var.remote_write_url_a
      remote_write_url_b  = var.remote_write_url_b
      tenant_name         = var.tenant_name
      client_id           = var.oidc_client_id
      client_secret       = var.oidc_client_secret
      oidc_token_url      = var.oidc_token_url
    })
  ]
}
