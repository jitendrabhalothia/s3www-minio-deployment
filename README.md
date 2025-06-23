---

# 🚀 UP42 Senior Cloud Engineer Challenge – s3www & MinIO Deployment

This project demonstrates a production-grade deployment of the `s3www` application using **Helm**, **Terraform**, **MinIO**, and **Kubernetes**.

### ✅ Key Features

* Infrastructure-as-Code with Terraform
* Helm charts for `s3www` and MinIO
* Sealed secrets for secure credential management
* Horizontal Pod Autoscaling (HPA)
* Prometheus metrics scraping support
* Task automation via `Taskfile.yml`

---

## 📦 Application Overview

* **s3www**: A Go-based static file server for S3-compatible storage
* **MinIO**: Lightweight, high-performance S3-compatible object storage
* **index.html**: Static HTML page served via `s3www` from MinIO

---

## ⚖️ Technologies Used

| Tool                   | Purpose                          |
| ---------------------- | -------------------------------- |
| Terraform              | Infrastructure orchestration     |
| Helm                   | Kubernetes deployment templating |
| MinIO                  | Local S3-compatible backend      |
| s3www                  | Static file server               |
| Bitnami Sealed Secrets | Secure secrets management        |
| Task                   | Developer workflow automation    |

---

## ✅ Prerequisites

* Docker Desktop with Kubernetes enabled (or Minikube)
* Terraform `>= 1.0`
* Helm `>= 3`
* [Task](https://taskfile.dev/#/installation) CLI
* [kubeseal CLI](https://github.com/bitnami-labs/sealed-secrets)

---

## 🆕 Multi-Taskfile Support & Secure Secrets

Secrets are modularized and managed via a dedicated Taskfile.

### 🔁 Taskfiles Overview

| Taskfile               | Description                    |
| ---------------------- | ------------------------------ |
| `Taskfile.yml`         | Infra setup (Terraform + Helm) |
| `Taskfile.secrets.yml` | Secrets generation and cleanup |

### 🔐 Secure MinIO Credentials

Set secrets locally:

```bash
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
```

They’re securely used in your Taskfile setup:

```yaml
kubectl create secret generic minio-creds \
  --from-literal=accesskey=${MINIO_ACCESS_KEY} \
  --from-literal=secretkey=${MINIO_SECRET_KEY}
```

---

## ⚙️ Deployment Options

### 🚀 Full Setup (Infra + Sealed Secrets)

```bash
task -t Taskfile.secrets.yml setup-secrets
task setup
```

### 🔁 Recreate Entire Setup

```bash
task -t Taskfile.secrets.yml destroy-secrets
task destroy
task -t Taskfile.secrets.yml setup-secrets
task setup
```

### 🧹 Cleanup

```bash
task destroy
task -t Taskfile.secrets.yml destroy-secrets
```

---

## ⚡ Developer Quick Start

```bash
git clone https://github.com/jitendrabhalothia/s3www-minio-deployment.git
cd s3www-minio-deployment

export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin

task -t Taskfile.secrets.yml setup-secrets
task setup
```

---

## ⚙️ Configuration

Editable values are in `charts/s3www/values.yaml`:

```yaml
s3www:
  image: y4m4/s3www:latest
  port: 8080

minio:
  credentialsSecret: minio-creds
  bucketName: mybuc
  fileName: index.html

hpa:
  enabled: true
  minReplicas: 1
  maxReplicas: 3
  targetCPU: 70

service:
  type: NodePort
```

> **Note:** `NodePort` is used for local development as Docker Desktop lacks `LoadBalancer` support.

---

## 🧪 Testing the Deployment

1. Check the service:

```bash
kubectl get svc s3www
```

2. Open in browser:

```
http://localhost:<NodePort>
```

You should see:

> ✅ Task Completed
> My name is Jitendra, and I have successfully completed the UP42 Senior Cloud Engineer Challenge.
> [GitHub Repository](https://github.com/jitendrabhalothia/s3www-minio-deployment)
> [GitHub Profile](https://github.com/jitendrabhalothia)

---

## 📂 Project Structure

```
.
├── CHALLENGE.md
├── README.md
├── charts/
│   └── s3www/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── files/
│       │   ├── index.html
│       │   └── minio-sealed-secret.yaml
│       └── templates/
│           ├── configmap.yaml
│           ├── s3www-deployment.yaml
│           ├── s3www-service.yaml
│           ├── s3www-hpa.yaml
│           ├── minio-deployment.yaml
│           ├── minio-service.yaml
│           ├── minio-secret.yaml
│           └── upload-job.yaml
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── Taskfile.yml
├── Taskfile.secrets.yml
└── .gitignore
```

---

## 👤 Author

**Jitendra Singh**
🚀 UP42 Senior Cloud Engineer Challenge

* 🔗 [GitHub Repository](https://github.com/jitendrabhalothia/s3www-minio-deployment)

---

## 📜 License

Licensed under the Apache 2.0 License.

---