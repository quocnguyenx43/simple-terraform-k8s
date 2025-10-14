pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  parameters {
    string(name: 'DOCKERHUB_USERNAME', defaultValue: '', description: 'Your Docker Hub username')
  }

  environment {
    APP_NAME = 'python-app'
    WORKDIR = 'python-app'
    VENV_DIR = '.venv'
    PIP_CACHE_DIR = "${WORKSPACE}/.cache/pip"
    REPORTS_DIR = 'reports'
    IMAGE_REPO = "docker.io/${params.DOCKERHUB_USERNAME}/${APP_NAME}"
    SHORT_SHA = "${env.GIT_COMMIT?.take(7)}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'git rev-parse --short HEAD > .git_short_sha || true'
        script { env.SHORT_SHA = readFile('.git_short_sha').trim() }
      }
    }

    // stage('Prepare Python Env') {
    //   steps {
    //     sh '''
    //       set -euxo pipefail
    //       python3 -V
    //       python3 -m venv "${VENV_DIR}"
    //       . "${VENV_DIR}/bin/activate"
    //       python -m pip install --upgrade pip wheel
    //       mkdir -p "${PIP_CACHE_DIR}" "${REPORTS_DIR}"
    //       PIP_CACHE_DIR="${PIP_CACHE_DIR}" pip install -r "${WORKDIR}/requirements.txt"
    //       # Dev/test tools
    //       PIP_CACHE_DIR="${PIP_CACHE_DIR}" pip install pytest pytest-cov ruff mypy bandit pip-audit
    //     '''
    //   }
    // }

    // stage('Lint / Type Check') {
    //   steps {
    //     sh '''
    //       set -euxo pipefail
    //       . "${VENV_DIR}/bin/activate"
    //       ruff check "${WORKDIR}" | tee "${REPORTS_DIR}/ruff.txt"
    //       mypy "${WORKDIR}" | tee "${REPORTS_DIR}/mypy.txt" || true
    //     '''
    //   }
    // }

    // stage('Unit / Integration Tests') {
    //   steps {
    //     sh '''
    //       set -euxo pipefail
    //       . "${VENV_DIR}/bin/activate"
    //       pytest -q "${WORKDIR}" \
    //         --junitxml="${REPORTS_DIR}/junit.xml" \
    //         --cov="${WORKDIR}" --cov-report=xml:"${REPORTS_DIR}/coverage.xml" --cov-report=term
    //     '''
    //   }
    //   post {
    //     always {
    //       junit allowEmptyResults: true, testResults: '${REPORTS_DIR}/junit.xml'
    //       archiveArtifacts artifacts: '${REPORTS_DIR}/*.xml, ${REPORTS_DIR}/*.txt', fingerprint: true, onlyIfSuccessful: false
    //       publishCoverage adapters: [coberturaAdapter('${REPORTS_DIR}/coverage.xml')], sourceFileResolver: sourceFiles('STORE_LAST_BUILD')
    //     }
    //   }
    // }

    // stage('Security Scans (SCA/SAST)') {
    //   steps {
    //     sh '''
    //       set -euxo pipefail
    //       . "${VENV_DIR}/bin/activate"
    //       bandit -r "${WORKDIR}" -f json -o "${REPORTS_DIR}/bandit.json" || true
    //       pip-audit -r "${WORKDIR}/requirements.txt" -f json -o "${REPORTS_DIR}/pip-audit.json" || true
    //     '''
    //   }
    //   post {
    //     always {
    //       archiveArtifacts artifacts: '${REPORTS_DIR}/*.json', fingerprint: true, onlyIfSuccessful: false
    //     }
    //   }
    // }

    stage('Build Docker Image') {
      steps {
        sh '''
          set -euxo pipefail
          IMAGE_TAG="${BRANCH_NAME}-${SHORT_SHA}"
          echo "Building ${IMAGE_REPO}:${IMAGE_TAG}"
          docker build -t "${IMAGE_REPO}:${IMAGE_TAG}" -f "${WORKDIR}/Dockerfile" "${WORKDIR}"
        '''
      }
    }

    stage('Trivy Image Scan') {
      steps {
        sh '''
          set -euxo pipefail
          IMAGE_TAG="${BRANCH_NAME}-${SHORT_SHA}"
          if command -v trivy >/dev/null 2>&1; then
            trivy image --skip-db-update --format json --output "${REPORTS_DIR}/trivy.json" "${IMAGE_REPO}:${IMAGE_TAG}" || true
          else
            echo "Trivy not installed on agent; skipping" | tee "${REPORTS_DIR}/trivy.txt"
          fi
        '''
      }
      post {
        always {
          archiveArtifacts artifacts: '${REPORTS_DIR}/trivy.*', fingerprint: true, onlyIfSuccessful: false
        }
      }
    }

    stage('Push Docker Image') {
      environment {
        DOCKERHUB_CREDS = credentials('dockerhub-credentials')
      }
      steps {
        sh '''
          set -euxo pipefail
          IMAGE_TAG="${BRANCH_NAME}-${SHORT_SHA}"
          echo "Logging in to Docker Hub as ${DOCKERHUB_USERNAME}"
          echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
          docker push "${IMAGE_REPO}:${IMAGE_TAG}"
          if [ "${BRANCH_NAME}" = "main" ] || [ "${BRANCH_NAME}" = "master" ]; then
            docker tag "${IMAGE_REPO}:${IMAGE_TAG}" "${IMAGE_REPO}:latest"
            docker push "${IMAGE_REPO}:latest"
          fi
        '''
      }
    }
  }

  post {
    success {
      echo "Build complete. Image pushed to ${IMAGE_REPO}:${BRANCH_NAME}-${SHORT_SHA}"
    }
    always {
      archiveArtifacts artifacts: '.git_short_sha', fingerprint: true, onlyIfSuccessful: false
    }
  }
}


