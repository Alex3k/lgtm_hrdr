terraform {
 
}

provider "google" {
  credentials = file(var.gcp_svc_acc_file_path)

  project = var.gcp_project_id
}


resource "google_compute_global_address" "grafana_global_ip" {
  name = "${var.owner_name}-hadr-grafana-lb-ip"
}

data "external" "grafana_a_gke_neg" {
  program = ["bash", "${path.module}/scripts/get-gcp-negs.sh"]
  query = {
    service = var.grafana_a_service_name
  }
}

data "external" "grafana_b_gke_neg" {
  program = ["bash", "${path.module}/scripts/get-gcp-negs.sh"]
  query = {
    service = var.grafana_b_service_name
  }
}

resource "google_compute_health_check" "grafana_global" {
  name = "${var.owner_name}-grafana-healthcheck"

  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 4
  unhealthy_threshold = 5

  http_health_check {
    port               = 3000
    port_specification = "USE_FIXED_PORT"
    host               = "1.2.3.4"
    request_path       = "/api/health"
  }
}

resource "google_compute_global_forwarding_rule" "grafana" {
  name       = "${var.owner_name}-hadr-grafana-lb"
  ip_address = var.grafana_global_ip_address
  port_range = "80"
  target     = google_compute_target_http_proxy.grafana_global.self_link
}

resource "google_compute_backend_service" "grafana_global" {
  name                  = "${var.owner_name}-grafana-backend"
  protocol              = "HTTP"
  timeout_sec           = 10
  session_affinity      = "NONE"
  load_balancing_scheme = "EXTERNAL"
  //locality_lb_policy    = "ROUND_ROBIN

  dynamic "backend" {
    for_each = keys(data.external.grafana_a_gke_neg.result)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 1000
    }
  }

  dynamic "backend" {
    for_each = keys(data.external.grafana_b_gke_neg.result)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 1000
    }
  }

  health_checks = [
    google_compute_health_check.grafana_global.id
  ]
}

resource "google_compute_url_map" "grafana_global" {
  name            = "${var.owner_name}-hadr-grafana"
  default_service = google_compute_backend_service.grafana_global.self_link
}

resource "google_compute_target_http_proxy" "grafana_global" {
  name    = "${var.owner_name}-hadr-grafana"
  url_map = google_compute_url_map.grafana_global.self_link
}
