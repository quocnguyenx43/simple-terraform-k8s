#!/usr/bin/env bash

source "$(dirname "$0")/utils.sh"

print_section "Configuring Jenkins Pipelines"

JENKINS_POD=$(kubectl get pods -n jenkins -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[0].metadata.name}')
ADMIN_PASS=$(kubectl get secret jenkins -n jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode)

echo "[jenkins] Using admin:${ADMIN_PASS}"

cat <<EOF | kubectl exec -i -n jenkins $JENKINS_POD -- /bin/bash -c "cat > /var/jenkins_home/init.groovy.d/bootstrap.groovy"
import jenkins.model.*
println "Bootstrapping Jenkins..."
EOF

# FROM jenkins/jenkins:lts-jdk17
# 
# USER root
# 
# # Install Docker CLI inside Jenkins container
# RUN apt-get update && \ 
#     apt-get install -y docker.io && \
#     rm -rf /var/lib/apt/lists/*
# 
# # Preinstall Jenkins plugins
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
# 
# # Copy Configuration-as-Code file
# COPY jenkins.yaml /var/jenkins_home/jenkins.yaml
# COPY init.groovy.d /var/jenkins_home/init.groovy.d
# 
# # Auto-load JCasC on startup
# ENV CASC_JENKINS_CONFIG=/var/jenkins_home/jenkins.yaml
# 
# USER jenkins
