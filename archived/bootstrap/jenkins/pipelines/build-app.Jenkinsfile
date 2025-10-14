pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/quocnguyenx43/simple-cicd-pipelines.git'
        BRANCH = 'master'
        IMAGE_NAME = 'docker.io/quocnguyenx43/prediction-app'
    }

    // triggers {
    //     githubPush()
    // }

    triggers {
        pollSCM('* * * * *')
    }

    options {
        skipDefaultCheckout()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: "*/${BRANCH}"]],
                    userRemoteConfigs: [[
                        url: "${REPO_URL}",
                        credentialsId: 'github-token'
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image ${IMAGE_NAME}:latest"
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    echo "Pushing image ${IMAGE_NAME}:latest"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "Build & push complete!"
        }
        failure {
            echo "Build & push failed!"
        }
    }
}
