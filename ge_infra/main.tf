terraform {
}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
}

resource "google_compute_global_address" "grafana_global_ip" {
  name   = "${var.owner_name}-ge-hadr-ip"
}
