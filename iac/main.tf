terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

#variable "do_token" {}

provider "digitalocean" {

  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_kubernetes" {

  name    = var.k8s_name
  region  = var.region
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}
# Declaro as variaveis.
variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s_kubernetes.endpoint
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8s_kubernetes.kube_config.0.raw_config
  filename = "kube_config.yaml"
}
