terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Your Helm chart for s3www + MinIO
resource "helm_release" "s3www" {
  name      = "s3www"
  chart     = "../charts/s3www"
  namespace = "default"
  values    = [file("../charts/s3www/values.yaml")]
}
