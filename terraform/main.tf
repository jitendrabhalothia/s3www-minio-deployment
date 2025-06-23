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

# Conditionally create namespace if it doesn't exist
resource "null_resource" "maybe_create_namespace" {
  provisioner "local-exec" {
    command = <<EOT
      if ! kubectl get namespace s3www-app >/dev/null 2>&1; then
        echo "🔧 Namespace 's3www-app' not found. Creating..."
        kubectl create namespace s3www-app
      else
        echo "✅ Namespace 's3www-app' already exists. Skipping creation."
      fi
    EOT
  }
}

# Deploy Helm chart
resource "helm_release" "s3www" {
  name       = "s3www"
  chart      = "../charts/s3www"
  namespace  = "s3www-app"

  depends_on = [null_resource.maybe_create_namespace]

  values     = [file("../charts/s3www/values.yaml")]
  version    = "0.1.0"
}
