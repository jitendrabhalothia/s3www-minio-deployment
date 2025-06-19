# UP42 Challenge

# 🚀 UP42 Senior Cloud Engineer Challenge – s3www & MinIO Deployment

This project demonstrates a production-grade deployment of the `s3www` application using **Helm**, **Terraform**, **MinIO**, and **Kubernetes**.

It includes:

* ✅ Infrastructure-as-Code using Terraform
* ✅ Helm charts for `s3www` and MinIO
* ✅ Sealed secrets for secure credential management
* ✅ Horizontal Pod Autoscaling (HPA)
* ✅ Support for Prometheus metrics scraping
* ✅ Task automation using `Taskfile.yml`

---

## 📦 Application Overview

* **s3www**: A Go-based static file server for S3-compatible storage.
* **MinIO**: Lightweight, high-performance S3-compatible object storage.
* **index.html**: A static HTML file served via s3www from MinIO.

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

## 🚀 Deployment Steps

### ✅ Prerequisites

* Docker Desktop with Kubernetes enabled (or Minikube)
* Terraform (`>=1.0`)
* Helm (`>=3`)
* Task runner: [Install Task](https://taskfile.dev/#/installation)

---

### 🧑‍💻 Quickstart (Automated)

Run the full deployment pipeline with one command:

```bash
task setup
```

This will:

1. Format and validate Terraform
2. Lint the Helm chart
3. Install the Sealed Secrets controller
4. Apply your sealed credentials for MinIO
5. Deploy `s3www` + MinIO
6. Show the status of deployed resources

---

## 🔑 Sealed Secrets

The MinIO credentials are encrypted using `kubeseal` and committed as a SealedSecret in:

```yaml
charts/s3www/files/minio-sealed-secret.yaml
```

You may regenerate this using your cluster’s public certificate if needed.

---

## ⚙️ Configuration Options

All configurable values live in `charts/s3www/values.yaml`:

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

---

## 🧪 Testing

After successful deployment, get the port with:

```bash
kubectl get svc s3www
```

Then open in your browser:

```bash
http://localhost:<nodePort>
```

You should see a page that reads:

> ✅ Task Completed
> My name is Jitendra, and I have successfully completed the UP42 Senior Cloud Engineer Challenge.
> [GitHub Repository](https://github.com/jitendrabhalothia/s3www-minio-deployment)
> [GitHub Profile](https://github.com/jitendrabhalothia)

---

## 🧺 Cleanup

To destroy all resources:

```bash
task destroy
```

---

## 📂 Project Structure

```
.
├── CHALLENGE.md                # Thought process and decisions
├── README.md                   # This documentation
├── charts/
│   └── s3www/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── files/
│       │   └── index.html
│       │   └── minio-sealed-secret.yaml
│       └── templates/
│           ├── s3www-deployment.yaml
│           ├── s3www-service.yaml
│           ├── s3www-hpa.yaml
│           ├── minio-deployment.yaml
│           ├── minio-service.yaml
│           ├── minio-secret.yaml
│           ├── configmap.yaml
│           └── upload-job.yaml
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── Taskfile.yml                # Task automation
└── .gitignore
```

---

## 👤 Author

**Jitendra Bhalothia**
This project was completed as part of the UP42 Senior Cloud Engineer Challenge.

* 🔗 GitHub Repo: [github.com/jitendrabhalothia/s3www-minio-deployment](https://github.com/jitendrabhalothia/s3www-minio-deployment)
* 👤 GitHub Profile: [github.com/jitendrabhalothia](https://github.com/jitendrabhalothia)

---

## 📜 License

Licensed under the Apache 2.0 License.
