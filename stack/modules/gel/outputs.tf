output "gateway_ip" {
  value = "http://${google_compute_address.gel_gateway_ip.address}"
}
