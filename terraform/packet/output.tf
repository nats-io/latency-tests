output "client_internal_ip" {
  value = "${lookup(packet_device.nats_client.0.network[2], "address")}"
}

output "client_external_ip" {
  value = "${lookup(packet_device.nats_client.0.network[0], "address")}"
}

output "server_a_internal_ip" {
  value = "${lookup(packet_device.nats_server_a.0.network[2], "address")}"
}

output "server_a_external_ip" {
  value = "${lookup(packet_device.nats_server_a.0.network[0], "address")}"
}

output "server_b_external_ip" {
  value = "${lookup(packet_device.nats_server_b.0.network[0], "address")}"
}

output "server_b_monitor_url" {
  value = "http://${lookup(packet_device.nats_server_b.0.network[0], "address")}:8222"
}

output "server_a_monitor_url" {
  value = "http://${lookup(packet_device.nats_server_a.0.network[0], "address")}:8222"
}

output "server_b_internal_ip" {
  value = "${lookup(packet_device.nats_server_b.0.network[2], "address")}"
}
