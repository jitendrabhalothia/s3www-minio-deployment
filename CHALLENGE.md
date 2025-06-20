# CHALLENGE.md

## 🎯 Challenge Objective

Deploy the `s3www` application and its dependency MinIO on Kubernetes using Helm and Terraform, ensuring production-readiness with features like secure secret handling, autoscaling, and observability.

---

## 🧠 Thought Process & Design Decisions

### 1. **Separation of Concerns**

* Used **Terraform** for infrastructure orchestration.
* Used **Helm** for Kubernetes resource templating and deployment.

### 2. **Helm Chart Structure**

* Built a modular Helm chart for `s3www` that includes:

  * `Deployment`, `Service`, and `HPA` for the application.
  * `StatefulSet` and `Service` for MinIO.
  * A `Job` to pre-upload content (`index.html`) into the MinIO bucket.

### 3. **Secrets Management**

* Used **Bitnami Sealed Secrets** to encrypt credentials for MinIO.
* This allows secrets to be stored safely in Git.
* `kubeseal` command documented for regenerating secrets securely.

### 4. **Access Type**

* Used **NodePort** instead of LoadBalancer due to Docker Desktop limitations.
* This ensures the application is accessible on `localhost:<nodePort>`.

### 5. **Horizontal Pod Autoscaling**

* Integrated HPA using resource requests/limits and CPU targets.
* Configurable via `values.yaml` to allow tuning without template changes.

### 6. **Observability (Future Ready)**

* Ensured `s3www` exposes metrics endpoint for Prometheus auto-discovery.
* Added correct annotations and port exposition in Helm values.

### 7. **Automation with Taskfile**

* Implemented developer automation using `Taskfile.yml`.
* Provides one-command `task setup` to install and deploy everything.

---

## 🔍 Trade-offs Considered

* **Security vs. Simplicity**: Used sealed secrets instead of simple Kubernetes secrets, which added complexity but improved security.
* **NodePort vs LoadBalancer**: Chose NodePort for local testing over LoadBalancer to stay compatible with Docker Desktop.
* **Static index.html**: Could have used initContainers to fetch from an external URL but kept the file local for simplicity.

---

## ⚠️ Known Limitations

* SealedSecret is namespace and controller specific; must be regenerated for other clusters.
* No real CI/CD pipeline—manual Task-based automation instead.
* Metrics endpoint in `s3www` is assumed; actual implementation of metrics exposition in app code is not validated.

---

## ✅ Strengths of Implementation

* Cleanly separated infrastructure and application concerns.
* Secure secret handling via Sealed Secrets.
* Modular, reusable Helm chart.
* Developer-friendly setup with a single task command.
* Production-aligned practices: autoscaling, metrics annotations, Kubernetes best practices.

---

## 🔁 Future Improvements

* Add CI/CD workflows using GitOps.
* Extend chart to support custom domain + TLS via Ingress.
* Add a `values.schema.json` to the Helm chart for strict validation.
* Test against multiple Kubernetes distros (e.g., Minikube, k3s).

---

## 🧪 Validation Performed

* Helm Lint
* Terraform Fmt & Validate
* Manual port check of `NodePort` URL
* Verified that MinIO bucket contained the correct `index.html`
* Confirmed Prometheus annotations are visible in deployment YAML

---

## 🧑 Author

**Jitendra Bhalothia**
[Repo Link](https://github.com/jitendrabhalothia/s3www-minio-deployment)
