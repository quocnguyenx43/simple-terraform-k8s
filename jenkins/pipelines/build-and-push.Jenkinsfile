pipeline {
  // Running as a Kubernetes pod
  agent {
    kubernetes {
      yaml """
      apiVersion: v1
      kind: Pod
      spec:
        containers:
        - name: docker
          image: docker:24.0.7-dind
          command:
          - cat
          tty: true
          securityContext:
            privileged: true
          volumeMounts:
          - name: docker-sock
            mountPath: /var/run/docker.sock
          lifecycle:
            postStart:
              exec:
                command:
                - /bin/sh
                - -c
                - |
                  echo "Installing git and curl inside pod..."
                  apk add --no-cache git curl bash >/dev/null
                  echo "Installed git, curl, bash."
        volumes:
        - name: docker-sock
          hostPath:
            path: /var/run/docker.sock
            type: Socket
      """
    }
  }

  // options {
  //  ansiColor('xterm') // Clear Jenkins output
  // }

  // Trigger every X minutes
  triggers {
    pollSCM('* * * * *')
  }

  parameters {
    string(
      name: 'REPO_URL',
      defaultValue: 'https://github.com/quocnguyenx43/simple-terraform-k8s.git',
      description: 'Your GitHub Repo URL'
    )
    string(
      name: 'BRANCH',
      defaultValue: 'master',
      description: 'Git branch to build'
    )
    booleanParam(name: 'GIT_INSECURE',
      defaultValue: true,
      description: 'Disable SSL verification for Git (insecure clone)'
    )
    string(name: 'DOCKERHUB_USERNAME',
      defaultValue: 'quocnguyenx43',
      description: 'Docker Hub username'
    )
    string(name: 'IMAGE_NAME',
      defaultValue: 'prediction-app',
      description: 'Docker image name'
    )
  }

  environment {
    IMAGE_REPO = "docker.io/${params.DOCKERHUB_USERNAME}/${params.IMAGE_NAME}"
  }

  stages {
    // Checkout and clone the repo
    stage('Checkout') {
      steps {
        container('docker') {
          script {
            echo "Preparing to clone ${params.REPO_URL} (branch: ${params.BRANCH})"

            withCredentials([
              usernamePassword(
                credentialsId: 'github-credentials',
                usernameVariable: 'GITHUB_USERNAME',
                passwordVariable: 'GITHUB_TOKEN'
              )
            ]) {
              if (params.GIT_INSECURE) {
                echo "Insecure clone mode — using git -c http.sslVerify=false"
                sh """
                  rm -rf repo && mkdir repo && cd repo
                  git -c http.sslVerify=false clone -b ${params.BRANCH} https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${params.REPO_URL.replace('https://', '')} .
                """
              }
              else {
                echo "Secure clone mode"
                dir('repo') {
                  deleteDir()
                  git branch: params.BRANCH, credentialsId: 'github-credentials', url: params.REPO_URL
                }
              }
            }

            echo "Repository cloned successfully."
          }
        }
      }
    }

//     stage('Prepare Python Env') {
//       steps {
//         container('python') {
//           sh '''
//             set -euxo pipefail
//             python3 -V
//             python3 -m venv "${VENV_DIR}" || true
//             . "${VENV_DIR}/bin/activate"
//             python -m pip install --upgrade pip wheel
//             mkdir -p "${PIP_CACHE_DIR}" "${REPORTS_DIR}"
//             PIP_CACHE_DIR="${PIP_CACHE_DIR}" pip install -r "${WORKDIR}/requirements.txt"
//             # Dev/test tools
//             PIP_CACHE_DIR="${PIP_CACHE_DIR}" pip install pytest pytest-cov ruff mypy bandit pip-audit
//           '''
//         }
//       }
//     }
// 
//     stage('Lint / Type Check') {
//       steps {
//         container('python') {
//           sh '''
//             set -euxo pipefail
//             . "${VENV_DIR}/bin/activate"
//             ruff check "${WORKDIR}" | tee "${REPORTS_DIR}/ruff.txt"
//             mypy "${WORKDIR}" | tee "${REPORTS_DIR}/mypy.txt" || true
//           '''
//         }
//       }
//     }
// 
//     stage('Unit / Integration Tests') {
//       steps {
//         container('python') {
//           sh '''
//             set -euxo pipefail
//             . "${VENV_DIR}/bin/activate"
//             pytest -q "${WORKDIR}" \
//               --junitxml="${REPORTS_DIR}/junit.xml" \
//               --cov="${WORKDIR}" --cov-report=xml:"${REPORTS_DIR}/coverage.xml" --cov-report=term
//           '''
//         }
//       }
//       post {
//         always {
//           junit allowEmptyResults: true, testResults: '${REPORTS_DIR}/junit.xml'
//           archiveArtifacts artifacts: '${REPORTS_DIR}/*.xml, ${REPORTS_DIR}/*.txt', fingerprint: true
//           publishCoverage adapters: [coberturaAdapter('${REPORTS_DIR}/coverage.xml')], sourceFileResolver: sourceFiles('STORE_LAST_BUILD')
//         }
//       }
//     }
// 
//     stage('Security Scans (SCA/SAST)') {
//       steps {
//         container('python') {
//           sh '''
//             set -euxo pipefail
//             . "${VENV_DIR}/bin/activate"
//             bandit -r "${WORKDIR}" -f json -o "${REPORTS_DIR}/bandit.json" || true
//             pip-audit -r "${WORKDIR}/requirements.txt" -f json -o "${REPORTS_DIR}/pip-audit.json" || true
//           '''
//         }
//       }
//       post {
//         always {
//           archiveArtifacts artifacts: '${REPORTS_DIR}/*.json', fingerprint: true
//         }
//       }
//     }

    // Build Docker image
    stage('Build Docker Image') {
      steps {
        container('docker') {
          sh '''
            set -euxo pipefail
            cd repo
            echo "Building Docker image ${IMAGE_REPO}:latest ..."
            docker build -t "${IMAGE_REPO}:latest" -f "prediction-app/Dockerfile" "prediction-app"
            echo "Successfully built ${IMAGE_REPO}:latest"
          '''
        }
      }
    }

//     stage('Trivy Image Scan') {
//       steps {
//         container('docker') {
//           sh '''
//             set -euxo pipefail
//             IMAGE_TAG="${BRANCH_NAME}-${SHORT_SHA}"
//             if command -v trivy >/dev/null 2>&1; then
//               trivy image --skip-db-update --format json --output "${REPORTS_DIR}/trivy.json" "${IMAGE_REPO}:${IMAGE_TAG}" || true
//             else
//               echo "Trivy not installed in docker agent; skipping" | tee "${REPORTS_DIR}/trivy.txt"
//             fi
//           '''
//         }
//       }
//       post {
//         always {
//           archiveArtifacts artifacts: '${REPORTS_DIR}/trivy.*', fingerprint: true
//         }
//       }
//     }

    // Push Docker image
    stage('Push Docker Image') {
      environment {
        DOCKERHUB_CREDS = credentials('dockerhub-credentials')
      }
      steps {
        container('docker') {
          sh '''
            set -euxo pipefail
            echo "Logging into Docker Hub as ${DOCKERHUB_USERNAME}..."
            echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS_USR" --password-stdin
            docker push "${IMAGE_REPO}:latest"
            echo "Successfully pushed ${IMAGE_REPO}:latest"
          '''
        }
      }
    }

    // Update Helm Chart in Github Repo for ArgoCD
    stage('Update Helm Image Tag in Git') {
      steps {
        container('docker') {
          script {
            echo "Updating Helm image tag in Git repo..."

            // Compute short commit hash or timestamp for tagging
            def IMAGE_TAG = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()

            // Push image with version tag
            sh """
              set -euxo pipefail
              docker tag "${IMAGE_REPO}:latest" "${IMAGE_REPO}:${IMAGE_TAG}"
              docker push "${IMAGE_REPO}:${IMAGE_TAG}"
            """

            // Commit Helm chart update
            withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
              if (params.GIT_INSECURE) {
                sh """
                  cd repo
                  git config user.name "jenkins-bot"
                  git config user.email "jenkins@local"

                  # Update the Helm values.yaml image tag
                  sed -i "s/tag: .*/tag: ${IMAGE_TAG}/" helm/prediction-app/values.yaml

                  git add helm/prediction-app/values.yaml
                  git commit -m "ci: update prediction-app image tag to ${IMAGE_TAG}" || echo "No changes to commit"

                  git -c http.sslVerify=false push https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${params.REPO_URL.replace('https://','')} ${params.BRANCH}
                """
              }
              else {
                sh """
                  cd repo
                  git config user.name "jenkins-bot"
                  git config user.email "jenkins@local"

                  # Update the Helm values.yaml image tag
                  sed -i "s/tag: .*/tag: ${IMAGE_TAG}/" helm/prediction-app/values.yaml

                  git add helm/prediction-app/values.yaml
                  git commit -m "ci: update prediction-app image tag to ${IMAGE_TAG}" || echo "No changes to commit"

                  git push https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@${params.REPO_URL.replace('https://','')} ${params.BRANCH}
                """
              }
            }

            echo "Helm values.yaml updated with tag: ${IMAGE_TAG}"
          }
        }
      }
    }
  }

  post {
    success {
      echo "Build and push complete: ${IMAGE_REPO}:latest"
    }
    failure {
      echo "Build failed."
    }
  }
}
