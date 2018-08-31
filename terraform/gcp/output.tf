output "client_internal_ip" {
  value = "${google_compute_instance.client.network_interface.0.address}"
}

output "client_external_ip" {
  value = "${google_compute_instance.client.network_interface.0.access_config.0.nat_ip}"
}

output "server_a_internal_ip" {
  value = "${google_compute_instance.servera.network_interface.0.address}"
}

output "server_a_external_ip" {
  value = "${google_compute_instance.servera.network_interface.0.access_config.0.nat_ip}"
}

output "server_b_internal_ip" {
  value = "${google_compute_instance.serverb.network_interface.0.address}"
}
output "server_b_external_ip" {
  value = "${google_compute_instance.serverb.network_interface.0.access_config.0.nat_ip}"
}

output "server_b_monitor_url" {
  value = "http://${google_compute_instance.serverb.network_interface.0.access_config.0.nat_ip}:8222"
}

output "server_a_monitor_url" {
  value = "http://${google_compute_instance.servera.network_interface.0.access_config.0.nat_ip}:8222"
}

