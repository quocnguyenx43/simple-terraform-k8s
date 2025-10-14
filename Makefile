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

boostrap:
	cd boostrap && ./run.sh && cd ..

.PHONY: infra boostrap
