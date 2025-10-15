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

  stages {
    stage('Check Git & Docker') {
      steps {
        container('docker') {
          sh '''
            echo "Checking if Git and Docker are installed..."
            git --version
            docker --version
            curl --version
            echo "Git, Curl, and Docker are available."
          '''
        }
      }
    }

    stage('Test GitHub Token') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(
            credentialsId: 'github-credentials',
            usernameVariable: 'GITHUB_USERNAME',
            passwordVariable: 'GITHUB_TOKEN'
          )]) {
            sh '''
              echo "Testing GitHub authentication for user: $GITHUB_USERNAME"
              curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" https://api.github.com/user || exit 1
              echo "GitHub authentication succeeded."
            '''
          }
        }
      }
    }

    stage('Test DockerHub Login') {
      steps {
        container('docker') {
          withCredentials([usernamePassword(
            credentialsId: 'dockerhub-credentials',
            usernameVariable: 'DOCKERHUB_USER',
            passwordVariable: 'DOCKERHUB_PASS'
          )]) {
            sh '''
              echo "Testing DockerHub login for user: $DOCKERHUB_USER"
              echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
              echo "DockerHub login succeeded."
            '''
          }
        }
      }
    }
  }
}
