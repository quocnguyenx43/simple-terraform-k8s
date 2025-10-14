pipeline {
    agent any

    // This triggers whenever "build-app" finishes successfully
    triggers {
        upstream(upstreamProjects: 'build-app', threshold: hudson.model.Result.SUCCESS)
    }

    stages {
        stage('Deploy Container') {
            steps {
                sh '''
                    NETWORK_NAME=$(docker network ls --format "{{.Name}}" | grep simple-cicd-pipelines | head -n 1)

                    if [ -z "$NETWORK_NAME" ]; then
                        echo "No network found containing 'simple-cicd-pipelines'."
                        exit 1
                    fi

                    echo "Using network: $NETWORK_NAME"

                    # Stop and remove old container if exists
                    if [ "$(docker ps -aq -f name=^prediction-app$)" ]; then
                        echo "Stopping and removing existing container..."
                        docker stop prediction-app || true
                        docker rm -v prediction-app || true
                    fi

                    docker run -d \
                        --name prediction-app \
                        -p 8000:8000 \
                        -e PROMETHEUS_MULTIPROC_DIR=/tmp \
                        --network "$NETWORK_NAME" \
                        $DOCKERHUB_USER/prediction-app:latest

                    echo "prediction-app deployed successfully!"
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment complete!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
