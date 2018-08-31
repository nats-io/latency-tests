# Configure the Packet Provider
provider "packet" {
  auth_token = "${var.auth_token}"
}

# Create a device for the server and add it to our project
resource "packet_device" "nats_server_a" {
  hostname         = "servera"
  plan             = "${var.server_type}"
  facility         = "${var.facility}"
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  project_id       = "${var.project_id}"
}

resource "packet_device" "nats_server_b" {
  hostname         = "serverb"
  plan             = "${var.server_type}"
  facility         = "${var.facility}"
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  project_id       = "${var.project_id}"
}

# Create devices for the latency clients and add it to our
# project
resource "packet_device" "nats_client" {
  hostname         = "client"
  plan             = "${var.client_type}"
  facility         = "${var.facility}"
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  project_id       = "${var.project_id}"
}

resource "null_resource" "client_update" {
  # Not perfect, but any changes to any instance of the machines 
  # requires updates
  triggers {
    cluster_instance_ids = "${packet_device.nats_client.id}, ${packet_device.nats_server_a.id}, ${packet_device.nats_server_b.id}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${lookup(packet_device.nats_client.0.network[0], "address")}"
  }

  provisioner "file" {
    source      = "../bootstrap/"
    destination = "~/"
  }

  provisioner "file" {
    source      = "../client/"
    destination = "~/"
  }
  provisioner "remote-exec" {
    # Add private_ip of each server in the cluster
    inline = [
      "chmod +x ~/*.sh",
      "~/install.sh",
      "echo '${lookup(packet_device.nats_server_a.0.network[2], "address")} servera servera.latency.nats.com' >> /etc/hosts ",
      "echo '${lookup(packet_device.nats_server_b.0.network[2], "address")} serverb serverb.latency.nats.com' >> /etc/hosts ",
    ]
  }

  depends_on = ["packet_device.nats_server_a", "packet_device.nats_server_b", "packet_device.nats_client"]
}

##
## This next set of resources updates the /etc/host files so
## we can have a static nats server config.
##
resource "null_resource" "servera_update" {
  # Not perfect, but any changes to any instance of the machines 
  # requires updates
  triggers {
    cluster_instance_ids = "${packet_device.nats_client.id}, ${packet_device.nats_server_a.id}, ${packet_device.nats_server_b.id}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${lookup(packet_device.nats_server_a.0.network[0], "address")}"
  }

  # Copy our install scripts to the machine
  provisioner "file" {
    source      = "../bootstrap/"
    destination = "~/"
  }

  provisioner "file" {
    source      = "../servera/"
    destination = "~/"
  }
  provisioner "remote-exec" {
    # Add private_ip of each server in the cluster
    inline = [
      "chmod +x ~/*.sh",
      "~/install.sh",
      "echo '${lookup(packet_device.nats_client.0.network[2], "address")}  client client.latency.nats.com' >> /etc/hosts ",
      "echo '${lookup(packet_device.nats_server_b.0.network[2], "address")} serverb serverb.latency.nats.com' >> /etc/hosts ",
      "~/run_server.sh",
    ]
  }

  depends_on = ["packet_device.nats_server_a", "packet_device.nats_server_b", "packet_device.nats_client"]
}

resource "null_resource" "serverb_update" {
  # Not perfect, but any changes to any instance of the machines 
  # requires updates
  triggers {
    cluster_instance_ids = "${packet_device.nats_client.id}, ${packet_device.nats_server_a.id}, ${packet_device.nats_server_b.id}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${lookup(packet_device.nats_server_b.0.network[0], "address")}"
  }

   # Copy our install script to the machine
  provisioner "file" {
    source      = "../bootstrap/"
    destination = "~/"
  }

  provisioner "file" {
    source      = "../serverb/"
    destination = "~/"
  } 

  provisioner "remote-exec" {
    # Add private_ip of each server in the cluster
    inline = [
      "chmod +x ~/*.sh",
      "~/install.sh",      
      "echo '${lookup(packet_device.nats_client.0.network[2], "address")} client client.latency.nats.com' >> /etc/hosts ",
      "echo '${lookup(packet_device.nats_server_a.0.network[2], "address")} servera servera.latency.nats.com' >> /etc/hosts ",
      "~/run_server.sh",
    ]
  }

  depends_on = ["packet_device.nats_server_a", "packet_device.nats_server_b", "packet_device.nats_client"]
}