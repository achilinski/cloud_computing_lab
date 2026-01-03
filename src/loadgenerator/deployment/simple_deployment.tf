
provider "google" {
  credentials = "${file(var.service_file)}"
  project     = var.project
  region      = var.region
  zone        = var.zone
}



resource "google_compute_instance" "vm_instance" {
  count        = 1
  name         = "${var.instance_name}-${count.index}"

  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  provisioner "local-exec" {
    command = "sleep 10"  # allow VM to fully boot
  }  
}

// A variable for extracting the external ip of the instance
output "ip" {
 value = "${google_compute_instance.vm_instance[0].network_interface.0.access_config.0.nat_ip}"
}
