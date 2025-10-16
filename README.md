## Simple Terraform + ArgoCD + Jenkins (CI/CD)

End-to-end DevOps lab that provisions Kubernetes infrastructure with Terraform, bootstraps GitOps with ArgoCD, and runs CI/CD with Jenkins. A sample `prediction-app` (Python) is deployed via Helm. Terraform is used only for infra and platform bootstrapping; application delivery and configuration are handled by ArgoCD/Helm.

### Architecture & Stack
- **Version Control (GitOps style)**: Git / GitHub (supports webhook integration).
- **Containerization**: Docker
- **Terraform**: Creates cluster resources, namespaces, storage, RBAC, and installs base platform tools.
- **ArgoCD (App-of-Apps)**: GitOps controller that syncs apps from this repo into the cluster.
- **Ingress NGINX**: Ingress controller for routing.
- **Jenkins**: CI/CD pipelines to build/push images and update Helm values.
- **Prometheus + Grafana**: Monitoring stack.
- **Prediction App**: Example Python service deployed with Helm.

### CI/CD Flow (High-Level)
- Developer pushes code to repo.
- Jenkins pipeline builds Docker image and pushes to registry.
- Optionally updates Helm `values.yaml` image tag (GitOps change) via PR.
- ArgoCD detects Git changes and syncs to the cluster.

## Repository Layout

```txt
simple-terraform-k8s/
├── argocd/
│   ├── root/                                 # Root app + repositories
│   │   └── root-app.yaml                     # App-of-Apps
│   │   ├── repositories.yaml
│   └── apps/                                 # Child Applications
│       ├── argocd-app.yaml                   # Manage ArgoCD itself
│       ├── grafana-app.yaml
│       ├── ingress-app.yaml
│       ├── jenkins-app.yaml
│       ├── prometheus-app.yaml
│       └── python-app.yaml                   # Deploy prediction-app (Helm)
│
├── helm/
│   ├── prediction-app/                       # Example app Helm chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       └── ingress.yaml
│   ├── shared-values/                        # Shared values are watched by ArgoCD apps
│   │   ├── argocd-values.yaml
│   │   ├── grafana-values.yaml
│   │   ├── ingress-nginx-values.yaml
│   │   ├── jenkins-values.yaml
│   │   └── prometheus-values.yaml
│   └── templates/                            # Kubernetes Secret templates
│       ├── argocd-repo-secret.yaml
│       └── jenkins-credentials.yaml
│
├── environments/                             # Environment-specific overrides
│   ├── dev/
│   │   └── values-dev.yaml
│   └── prod/
│       └── values-prod.yaml
│
├── infrastructure/                           # Terraform for infra/platform
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── argocd.tf
│   ├── ingress.tf
│   ├── jenkins.tf
│   ├── grafana.tf
│   └── prometheus.tf
│
├── manifests/                                # Constant manifests, rearly change
│   ├── ingress-nginx/
│   │   └── controller.yaml
│   └── monitoring/
│       └── service-monitor.yaml
│
├── jenkins/
│   └── pipelines/
│       ├── build-and-push.Jenkinsfile
│       └── credentials-test.Jenkinsfile
│
├── prediction-app/                           # Sample ML Python service
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   ├── main.py
│   ├── requirements.txt
│   ├── schema.py
│   └── utils/
│       ├── __init__.py
│       ├── data_processing.py
│       └── logging.py
│
├── scripts/
│   ├── render-argocd-repo-secret.sh
│   └── render-jenkins-credentials.sh
│
├── .env
├── .gitignore
├── Makefile
├── LICENSE
└── README.md
```

### Philosophy
- Use Terraform strictly for cluster-level bootstrapping (providers, cluster, namespaces, storage, RBAC, base platforms like ArgoCD/Jenkins/Ingress/Monitoring).
- Use ArgoCD + Helm for application lifecycle and configuration. Avoid `helm_release` inside Terraform for apps.

## Prerequisites
- Terraform
- Docker
- kubectl
- helm
- Container registry credentials: DockerHub

## Reproduction

### 1) Provision Infra and Base Platforms

```bash
# pure terraform
cd infrastructure
terraform init
terraform apply

# or with Makefile
make infra
```

Verify:

```bash
kubectl get pods -A -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase'
```

### 2) Access ArgoCD UI (optional to see what happen)
```bash
kubectl port-forward svc/argocd-server -n argocd 8000:80
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

### 3) Register Git Repository and Bootstrap App-of-Apps

#### Step 1: Configure Repository Credentials

You have two options to add the repository credentials:

**Option A: Direct Modification**

Directly modify the `username` and `password` fields in `argocd/root/repositories.yaml`, then apply:
```bash
kubectl apply -f argocd/root/repositories.yaml
```

**Option B: Using Environment Variables (Recommended)**

Generate and apply the manifest using credentials from your `.env` file:
```bash
make argocd-secret-values
make argocd-apply-secrets
```

#### Step 2: Deploy Root Application

Apply the root application manifest:
```bash
kubectl apply -f argocd/root/root-app.yaml
```

ArgoCD will automatically sync all child applications, including:
- ArgoCD itself
- Ingress
- Jenkins
- Prometheus
- Grafana
- The `prediction-app`

### 4) Configure Jenkins Credentials

Before proceeding, ensure you have set the required credentials in your `.env` file (e.g., registry username/password, tokens).

Render and apply Jenkins credentials using the values from your `.env` file:

```bash
make jenkins-creds-values
make jenkins-apply-creds
```

Wait for Jenkins to restart with the new credentials:

```bash
kubectl get pods -n jenkins
```

Monitor the pod status until Jenkins is running and ready.

### 5) Add Jenkins Pipelines
Place pipelines under `jenkins/pipelines/`, e.g.:
- `credentials-test.Jenkinsfile` – validates credentials
- `build-and-push.Jenkinsfile` – builds the prediction app image and pushes to registry

Trigger a pipeline run from Jenkins UI.

## Environments and Values
- Base chart values live under `helm/prediction-app/values.yaml`.
- Environment overrides live under `environments/dev/values-dev.yaml` and `environments/prod/values-prod.yaml`.
- ArgoCD Applications reference these values to deploy per environment.

## Local Development (prediction-app)
```bash
cd prediction-app
docker compose up --build -d
```

### Author
__Maintained by Quoc Nguyen__
- GitHub: [@quocnguyenx43](https://github.com/quocnguyenx43/)
- LinkedIn: [@quocnguyenx43](https://www.linkedin.com/in/quocnguyenx43/)
- Email: [quocnguyenx43@gmail.com](mailto:{quocnguyenx43@gmail.com})
