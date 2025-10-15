pipeline {
    agent any

    stages {
        // stage('Check Git & Docker') {
        //     steps {
        //         echo 'Checking if Git and Docker are installed...'
        //         sh 'git --version'
        //         sh 'docker --version'
        //         echo 'Git and Docker are installed'
        //     }
        // }

        stage('Test GitHub Token') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-credentials',
                    usernameVariable: 'GITHUB_USERNAME',
                    passwordVariable: 'GITHUB_TOKEN'
                )]) {
                    echo "Testing GitHub authentication for user: ${GITHUB_USERNAME}"
                    sh '''
                        echo "Testing GitHub token..."
                        curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" https://api.github.com/user
                    '''
                }
            }
        }

        stage('Test DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    echo "Testing DockerHub login for user: ${DOCKERHUB_USER}"
                    sh '''
                        echo "Attempting DockerHub login..."
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    '''
                }
            }
        }
    }
}