terraform {

}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
  region  = var.gcp_region
}

resource "google_compute_address" "ge_ip_address" {
  name   = "${var.owner_name}-ge-${var.identifier}-ip"
  region = var.gcp_region
}

