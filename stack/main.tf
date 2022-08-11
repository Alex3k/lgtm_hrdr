terraform {
}

// Common Configuration
provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
}

data "google_client_config" "provider" {}


resource "random_password" "grafana_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


// --------------------------------------------------------
// Region A Configuration

resource "google_container_cluster" "region_a" {
  name               = var.gcp_gke_cluster_name_a
  location           = var.gcp_region_a
  initial_node_count = 1
  resource_labels = {
    owner = var.owner_name
  }
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {

  }
  node_config {
    preemptible  = false
    machine_type = "e2-standard-8"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      owner = var.owner_name
    }
  }
}

provider "kubernetes" {
  alias                  = "region_a"
  host                   = "https://${google_container_cluster.region_a.endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.region_a.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  alias = "region_a"
  kubernetes {
    host                   = "https://${google_container_cluster.region_a.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.region_a.master_auth.0.cluster_ca_certificate)
  }
}

module "gem_a" {
  source = "./modules/gem"

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path
  gcp_region            = var.gcp_region_a
  gke_cluster_name      = google_container_cluster.region_a.name

  gcp_gcs_bucket_prefix    = "${var.owner_name}-hadr-gem-${var.gcp_region_a}"
  owner_name               = var.owner_name
  gem_cluster_name         = var.gem_a_cluster_name
  gem_license_file         = var.gem_a_license_file
  gem_admin_token_override = var.gem_admin_token_override
  oidc_issuer_url          = var.oidc_issuer_url
  oidc_access_policy_claim = var.oidc_access_policy_claim

  authproxy_name_prefix = var.authproxy_name_prefix

  depends_on = [
    google_container_cluster.region_a
  ]

  providers = {
    google     = google,
    kubernetes = kubernetes.region_a,
    helm       = helm.region_a
  }
}


module "gel_a" {
  source = "./modules/gel"

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path
  gcp_region            = var.gcp_region_a
  gke_cluster_name      = google_container_cluster.region_a.name
  gcp_gcs_bucket_name   = "${var.owner_name}-hadr-gel-storage-${var.gcp_region_a}"

  owner_name               = var.owner_name
  gel_cluster_name         = var.gel_a_cluster_name
  gel_license_file         = var.gel_a_license_file
  gel_admin_token_override = var.gel_admin_token_override
  oidc_issuer_url          = var.oidc_issuer_url
  oidc_access_policy_claim = var.oidc_access_policy_claim

  depends_on = [
    google_container_cluster.region_a
  ]

  providers = {
    google     = google,
    kubernetes = kubernetes.region_a,
    helm       = helm.region_a
  }
}

module "grafana_a" {
  source = "./modules/grafana"

  gcp_project_id = var.gcp_project_id

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path

  owner_name = var.owner_name

  gcp_region = var.gcp_region_a

  ge_deployment_name = var.grafana_a_deployment_name

  gke_cluster_name = google_container_cluster.region_a.name

  ge_ip_address = var.grafana_global_ip_address

  ge_license_file = var.grafana_global_license_file
  admin_password  = random_password.grafana_password.result

  mysql_database_name = var.grafana_a_mysql_database_name

  oidc_client_id              = var.oidc_client_id
  oidc_client_secret          = var.oidc_client_secret
  oidc_auth_url               = var.oidc_auth_url
  oidc_token_url              = var.oidc_token_url
  oidc_userinfo_url           = var.oidc_userinfo_url
  grafana_role_attribute_path = var.grafana_role_attribute_path

  gem_token    = var.gem_admin_token_override
  gem_endpoint = module.gem_a.admin_endpoint

  gel_token    = var.gel_admin_token_override
  gel_endpoint = module.gel_a.gateway_ip

  providers = {
    google     = google,
    kubernetes = kubernetes.region_a,
    helm       = helm.region_a
  }

  depends_on = [
    google_container_cluster.region_a
  ]
}

module "grafana_agent_a" {
  source = "./modules/grafana_agent"

  gcp_project_id = var.gcp_project_id

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path

  gcp_region = var.gcp_region_a

  gke_cluster_name = google_container_cluster.region_a.name

  tenant_name        = var.data_shipper_tenant_name
  oidc_client_id     = var.data_shipper_oidc_client_id
  oidc_client_secret = var.data_shipper_oidc_client_secret
  oidc_token_url     = var.data_shipper_oidc_token_url

  gem_remote_write_url_a = "${module.gem_a.gateway_ip}/prometheus"
  gem_remote_write_url_b = "${module.gem_b.gateway_ip}/prometheus"

  gel_a_endpoint = "${module.gel_a.gateway_ip}/loki/api/v1/push"
  gel_b_endpoint = "${module.gel_b.gateway_ip}/loki/api/v1/push"

  providers = {
    google     = google,
    kubernetes = kubernetes.region_a,
    helm       = helm.region_a
  }

  depends_on = [
    google_container_cluster.region_a
  ]
}


// --------------------------------------------------------
// Region B Configuration

resource "google_container_cluster" "region_b" {
  name               = var.gcp_gke_cluster_name_b
  location           = var.gcp_region_b
  initial_node_count = 1
  resource_labels = {
    owner = var.owner_name
  }
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {

  }
  node_config {
    preemptible  = false
    machine_type = "e2-standard-8"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      owner = var.owner_name
    }
  }
}


provider "kubernetes" {
  alias                  = "region_b"
  host                   = "https://${google_container_cluster.region_b.endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.region_b.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  alias = "region_b"
  kubernetes {
    host                   = "https://${google_container_cluster.region_b.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.region_b.master_auth.0.cluster_ca_certificate)
  }
}

module "gem_b" {
  source = "./modules/gem"

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path
  gcp_region            = var.gcp_region_b
  gke_cluster_name      = google_container_cluster.region_a.name

  gcp_gcs_bucket_prefix    = "${var.owner_name}-hadr-gem-${var.gcp_region_b}"
  owner_name               = var.owner_name
  gem_cluster_name         = var.gem_b_cluster_name
  gem_license_file         = var.gem_b_license_file
  gem_admin_token_override = var.gem_admin_token_override
  oidc_issuer_url          = var.oidc_issuer_url
  oidc_access_policy_claim = var.oidc_access_policy_claim

  authproxy_name_prefix = var.authproxy_name_prefix

  depends_on = [
    google_container_cluster.region_b
  ]

  providers = {
    google     = google,
    kubernetes = kubernetes.region_b,
    helm       = helm.region_b
  }
}

module "gel_b" {
  source = "./modules/gel"

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path
  gcp_region            = var.gcp_region_b
  gke_cluster_name      = google_container_cluster.region_b.name
  gcp_gcs_bucket_name   = "${var.owner_name}-hadr-gel-storage-${var.gcp_region_b}"

  owner_name               = var.owner_name
  gel_cluster_name         = var.gel_b_cluster_name
  gel_license_file         = var.gel_b_license_file
  gel_admin_token_override = var.gel_admin_token_override
  oidc_issuer_url          = var.oidc_issuer_url
  oidc_access_policy_claim = var.oidc_access_policy_claim

  depends_on = [
    google_container_cluster.region_b
  ]

  providers = {
    google     = google,
    kubernetes = kubernetes.region_b,
    helm       = helm.region_b
  }
}

module "grafana_b" {
  source = "./modules/grafana"

  gcp_project_id = var.gcp_project_id

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path

  owner_name = var.owner_name

  gcp_region = var.gcp_region_b

  ge_deployment_name = var.grafana_b_deployment_name

  gke_cluster_name = google_container_cluster.region_a.name

  ge_ip_address = var.grafana_global_ip_address

  ge_license_file = var.grafana_global_license_file
  admin_password  = random_password.grafana_password.result

  mysql_database_name = var.grafana_b_mysql_database_name

  oidc_client_id              = var.oidc_client_id
  oidc_client_secret          = var.oidc_client_secret
  oidc_auth_url               = var.oidc_auth_url
  oidc_token_url              = var.oidc_token_url
  oidc_userinfo_url           = var.oidc_userinfo_url
  grafana_role_attribute_path = var.grafana_role_attribute_path

  gem_token    = var.gem_admin_token_override
  gem_endpoint = module.gem_b.admin_endpoint

  gel_token    = var.gel_admin_token_override
  gel_endpoint = module.gel_b.gateway_ip

  providers = {
    google     = google,
    kubernetes = kubernetes.region_b,
    helm       = helm.region_b
  }

  depends_on = [
    google_container_cluster.region_b
  ]
}

module "grafana_agent_b" {
  source = "./modules/grafana_agent"

  gcp_project_id = var.gcp_project_id

  gcp_svc_acc_file_path = var.gcp_svc_acc_file_path

  gcp_region = var.gcp_region_b

  gke_cluster_name = google_container_cluster.region_b.name

  tenant_name        = var.data_shipper_tenant_name
  oidc_client_id     = var.data_shipper_oidc_client_id
  oidc_client_secret = var.data_shipper_oidc_client_secret
  oidc_token_url     = var.data_shipper_oidc_token_url

  gem_remote_write_url_a = module.gem_a.ingest_endpoint
  gem_remote_write_url_b = module.gem_b.ingest_endpoint

  gel_a_endpoint = "${module.gel_a.gateway_ip}/loki/api/v1/push"
  gel_b_endpoint = "${module.gel_b.gateway_ip}/loki/api/v1/push"

  providers = {
    google     = google,
    kubernetes = kubernetes.region_b,
    helm       = helm.region_b
  }

  depends_on = [
    google_container_cluster.region_b
  ]
}