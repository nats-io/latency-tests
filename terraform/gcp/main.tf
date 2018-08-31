
provider "google" {
  credentials = "${file("${var.account_json_file}")}"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_network" "lattest-network" {
  name                    = "lattest-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "lattest-firewall" {
  name    = "lattest-firewall"
  network = "lattest-network"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "4222", "4244", "8222"]
  }

  depends_on = ["google_compute_network.lattest-network"] 
}

# Create a new instance
resource "google_compute_instance" "servera" {
   name = "servera"
   machine_type = "${var.server_type}"
   zone = "${var.zone}"
   boot_disk {
      initialize_params {
          image = "ubuntu-1604-lts"
      }
   }

   network_interface {
    network = "lattest-network"
      access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

   depends_on = ["google_compute_network.lattest-network"]
}

resource "google_compute_instance" "serverb" {
   name = "serverb"
   machine_type = "${var.server_type}"
   min_cpu_platform = "${var.min_cpu_platform}"
   zone = "${var.zone}"
   boot_disk {
      initialize_params {
      image = "ubuntu-1604-lts"
      }
   }

   network_interface {
    network = "lattest-network"
      access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

   depends_on = ["google_compute_network.lattest-network"] 
}

resource "google_compute_instance" "client" {
   name = "client"
   machine_type = "${var.client_type}"
   min_cpu_platform = "${var.min_cpu_platform}"
   zone = "${var.zone}"
   boot_disk {
      initialize_params {
      image = "ubuntu-1604-lts"
      }
   }

  network_interface {
    network = "lattest-network"
      access_config {}
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  depends_on = ["google_compute_network.lattest-network"]
}

resource "null_resource" "client_update" {
  # Not perfect, but any changes to any instance of the machines 
  # requires updates
  triggers {
    cluster_instance_ids = "${google_compute_instance.client.id}, ${google_compute_instance.servera.id}, ${google_compute_instance.serverb.id}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${google_compute_instance.client.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "${var.username}"
    private_key = "${file("${var.private_key_file}")}"
  }
  
   # Copy our install script to the machine
  provisioner "file" {
    source      = "../bootstrap/"
    destination = "/home/${var.username}"
  }

  provisioner "file" {
    source      = "../client/"
    destination = "/home/${var.username}" 
  } 

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.username}/*.sh",
      "/home/${var.username}/install.sh",
    ]
  }

  depends_on = ["google_compute_instance.client"]
}

resource "null_resource" "servera_update" {
  # Not perfect, but any changes to any instance of the machines 
  # requires updates
  triggers {
    cluster_instance_ids = "${google_compute_instance.client.id}, ${google_compute_instance.servera.id}, ${google_compute_instance.serverb.id}"
  }

  connection {
    host = "${google_compute_instance.servera.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "${var.username}"
    private_key = "${file("${var.private_key_file}")}"
  } 

   # Copy our install script to the machine
  provisioner "file" {
    source      = "../bootstrap/"
    destination = "/home/${var.username}" 
  }

  provisioner "file" {
    source      = "../servera/"
    destination = "/home/${var.username}"     
  } 

  provisioner "remote-exec" {
    # Add private_ip of each server in the cluster
    inline = [
      "chmod +x /home/${var.username}/*.sh",
      "/home/${var.username}/install.sh",
      "/home/${var.username}/run_server.sh"
    ]
  }

  depends_on = ["google_compute_instance.servera"]
}

resource "null_resource" "serverb_update" {
  # Not perfect, but any changes to any instance of the machines 
  # requires updates
  triggers {
    cluster_instance_ids = "${google_compute_instance.client.id}, ${google_compute_instance.servera.id}, ${google_compute_instance.serverb.id}"
  }

  connection {
    host = "${google_compute_instance.serverb.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "${var.username}"
    private_key = "${file("${var.private_key_file}")}"
  } 

   # Copy our install script to the machine
  provisioner "file" {
    source      = "../bootstrap/"
    destination = "/home/${var.username}"
  }

  provisioner "file" {
    source      = "../serverb/"
    destination = "/home/${var.username}"     
  } 

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.username}/*.sh",
      "/home/${var.username}/install.sh",
      "/home/${var.username}/run_server.sh"
    ]
  }

  depends_on = ["google_compute_instance.serverb"]
}