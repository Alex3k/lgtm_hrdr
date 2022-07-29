terraform {
}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
  region  = var.gcp_region
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id   = var.gcp_project_id
  cluster_name = var.gke_cluster_name
  location     = var.gcp_region
}

provider "kubernetes" {
  host                   = "${module.gke_auth.host}"
  token                  = module.gke_auth.token
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = "${module.gke_auth.host}"
    token                  = module.gke_auth.token
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  }
}

resource "helm_release" "agent" {
  chart      = "./agent"
  name       = "grafana-agent"

  values = [
    templatefile("${path.module}/agent_overrides.yaml", {
      cluster_label_value = var.gcp_region
      remote_write_url_a = var.remote_write_url_a
      remote_write_url_b = var.remote_write_url_b
      tenant_name = var.tenant_name
      client_id = var.oidc_client_id
      client_secret = var.oidc_client_secret
      oidc_token_url = var.oidc_token_url
    })
  ]

  depends_on = [
  ]
}
