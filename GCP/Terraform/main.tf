provider "google" {
  project = "data-proc-test-dla"
  region  = "europe-west1"
  zone    = "europe-west1-b"
  version = "~> 3.44"
  credentials = file("/home/leslie_johnson/secrets/data-proc-test-dla-b37293a8c6d0.json")
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "FireWall_rule" {
  name    = "terraform-network-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
