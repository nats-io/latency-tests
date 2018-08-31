# GCE Project ID
variable project {}

# This is the account json credentials file with your private key and 
# other credentials.
variable account_json_file {}
# GCE username used to connect to the instance.
# This must be in the private key.
variable username {}

# Private key for the ssh connection to the GCE instances for 
# the user define in "username"
variable private_key_file {
  default = "~/.ssh/google_compute_engine"
}

#
# Machine type reference (July 2018)
# gcloud compute machine-types list | grep us-west-2a
# NAME             ZONE                       CPUS  MEMORY_GB  DEPRECATED
# f1-micro         us-west2-a                 1     0.60
# g1-small         us-west2-a                 1     1.70
# n1-highcpu-16    us-west2-a                 16    14.40
# n1-highcpu-2     us-west2-a                 2     1.80
# n1-highcpu-32    us-west2-a                 32    28.80
# n1-highcpu-4     us-west2-a                 4     3.60
# n1-highcpu-64    us-west2-a                 64    57.60
# n1-highcpu-8     us-west2-a                 8     7.20
# n1-highcpu-96    us-west2-a                 96    86.40
# n1-highmem-16    us-west2-a                 16    104.00
# n1-highmem-2     us-west2-a                 2     13.00
# n1-highmem-32    us-west2-a                 32    208.00
# n1-highmem-4     us-west2-a                 4     26.00
# n1-highmem-64    us-west2-a                 64    416.00
# n1-highmem-8     us-west2-a                 8     52.00
# n1-highmem-96    us-west2-a                 96    624.00
# n1-standard-1    us-west2-a                 1     3.75
# n1-standard-16   us-west2-a                 16    60.00
# n1-standard-2    us-west2-a                 2     7.50
# n1-standard-32   us-west2-a                 32    120.00
# n1-standard-4    us-west2-a                 4     15.00
# n1-standard-64   us-west2-a                 64    240.00
# n1-standard-8    us-west2-a                 8     30.00
# n1-standard-96   us-west2-a                 96    360.00

variable server_type {
  default = "n1-highcpu-2"
}

variable client_type {
  default = "n1-highcpu-2"
}

# CPU Platform options include:
# Intel Xeon E5 (Sandy Bridge) processors: "Intel Sandy Bridge"
# Intel Xeon E5 v2 (Ivy Bridge) processors: "Intel Ivy Bridge"
# Intel Xeon E5 v3 (Haswell) processors: "Intel Haswell"
# Intel Xeon E5 v4 (Broadwell) processors: "Intel Broadwell"
# Intel Xeon (Skylake) processors: "Intel Skylake"
variable min_cpu_platform {
  default = "Intel Skylake"
}

variable zone {
  default = "us-west2-a"
}

variable region {
  default = "us-west2"
}