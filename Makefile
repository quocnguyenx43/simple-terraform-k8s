default: up

up: infra boostrap

infra:
	cd terraform && \
	terraform init && \
	terraform apply -auto-approve && \
	cd ..

destroy:
	cd terraform && \
	terraform destroy -auto-approve && \
	cd ..

boostrap:
	cd boostrap && ./run.sh && cd ..

.PHONY: infra boostrap
