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

resource "helm_release" "s3www" {
  name      = "s3www"
  chart     = "../charts/s3www"
  namespace = "default"
  values    = [file("../charts/s3www/values.yaml")]

  depends_on = [helm_release.sealed_secrets]
}

resource "helm_release" "sealed_secrets" {
  name      = "sealed-secrets"
  namespace = "kube-system"

  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.15.3" # Latest stable version as of June 2025

  create_namespace = false

  # Optional: wait for controller to be ready
  wait = true
}