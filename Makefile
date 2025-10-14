default: up

up: infra boostrap

infra:
	cd infrastructure && \
	terraform init && \
	terraform apply -auto-approve && \
	cd ..

destroy:
	cd infrastructure && \
	terraform destroy -auto-approve && \
	cd ..

clean-creds:
	rm -rf ./helm/rendered/jenkins-credentials.yaml
	rm -rf ./helm/rendered/argocd-repo-secret.yaml

jenkins-creds-values:
	@if [ ! -f .env ]; then echo "Missing .env. Add GITHUB_*, DOCKERHUB_* vars."; exit 1; fi
	bash scripts/render-jenkins-credentials.sh

jenkins-apply-creds:
	@if [ ! -f helm/rendered/jenkins-credentials.yaml ]; then echo "Run 'make jenkins-creds-values' first"; exit 1; fi
	# Ensure namespace and Helm repo
	kubectl get ns jenkins >/dev/null 2>&1 || kubectl create ns jenkins
	helm repo add jenkins https://charts.jenkins.io >/dev/null 2>&1 || true
	helm repo update >/dev/null
	# Install/upgrade Jenkins from official chart repo
	helm upgrade --install jenkins jenkins/jenkins \
		-f helm/shared-values/jenkins-values.yaml \
		-f helm/rendered/jenkins-credentials.yaml \
		-n jenkins

argocd-secret-values:
	@if [ ! -f .env ]; then echo "Missing .env. Add ARGOCD_REPO_*, GITHUB_* vars."; exit 1; fi
	bash scripts/render-argocd-repo-secret.sh

argocd-apply-secret:
	@if [ ! -f helm/rendered/argocd-repo-secret.yaml ]; then echo "Run 'make argocd-secret-values' first"; exit 1; fi
	kubectl apply -f helm/rendered/argocd-repo-secret.yaml

.PHONY: infra boostrap
