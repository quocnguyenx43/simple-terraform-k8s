Use Terraform only for infra & platform bootstra

devops-lab/
├── argocd/
│   ├── root-app.yaml                      # The App-of-Apps (bootstraps all apps)
│   └── apps/                              # Each sub-app (child Application)
│       ├── argocd-app.yaml                # Manage ArgoCD itself
│       ├── jenkins-app.yaml               # Jenkins CI/CD
│       ├── ingress-app.yaml               # Nginx ingress routes / controllers
│       ├── prometheus-app.yaml            # Monitoring
│       ├── grafana-app.yaml               # Visualization
│       └── python-app.yaml                # Your own app (Helm or YAML)
│
├── helm/                                  # Helm chart definitions for custom apps
│   ├── python-app/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       └── ingress.yaml
│   └── shared-values/
│       ├── ingress-values.yaml
│       ├── jenkins-values.yaml
│       └── grafana-values.yaml
│
├── manifests/                             # Plain YAML apps (non-Helm)
│   ├── prometheus/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── grafana/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── ingress-nginx/
│       └── controller.yaml
│
├── environments/                          # Environment-specific configs
│   ├── dev/
│   │   └── values-dev.yaml
│   └── prod/
│       └── values-prod.yaml
│
├── infra/                                 # Terraform cluster & infra provisioning
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── README.md


1. infra/	Terraform	Creates the cluster and installs base platform tools (ArgoCD, NGINX, Jenkins, Prometheus, Grafana).
2. argocd/	ArgoCD YAMLs	Defines how each app (including ArgoCD itself) should sync from Git → Cluster.
3. helm/	Helm charts	Contains templated deployments for your own apps (like Python app) or overrides (values.yaml) for others.
4. manifests/	Plain YAML resources	For static things that don’t need Helm (e.g. CRDs, NGINX routes, static configs).
5. environments/	Environment-specific overrides	Holds “values-dev.yaml” or “values-prod.yaml” — what changes between environments.

# Apply
terraform apply

# Check
docker ps -a
kubectl get pods -A -o wide

# Access Argo
kubectl port-forward svc/argocd-server -n argocd 8000:80
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

# Add Argo Repo & Root app
kubectl apply -f argocd/root/repositories.yaml
make argocd-secret-values
make argocd-apply-secrets
kubectl apply -f argocd/root/root-app.yaml

# Add Jenkins credentials
make jenkins-creds-values
make jenkins-apply-creds

waitl

dont use Terraform with Helm to create and config services,
just use for create cluster, namespaces, RBAC, storage,...
cluster, nodes, storage, ingress
