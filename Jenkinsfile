pipeline {

    agent any

    environment {

        APP_NAME = "ecommerce-backend"

        IMAGE_NAME = "ecommerce-backend"

        IMAGE_TAG = "${BUILD_NUMBER}"

        DOCKER_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"

        CONTAINER_NAME = "ecommerce-backend"

        COMPOSE_FILE = "docker-compose.yml"

    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "========== CHECKOUT =========="
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                echo "========== MAVEN BUILD =========="
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {

                echo "========== BUILD IMAGE =========="

                sh """
                    docker build -t ${DOCKER_IMAGE} .
                    docker tag ${DOCKER_IMAGE} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Stop Existing Containers') {
            steps {

                echo "========== STOP OLD CONTAINERS =========="

                sh """
                    docker compose -f ${COMPOSE_FILE} down || true
                """
            }
        }

        stage('Deploy Application') {

    steps {

        echo "========== DEPLOY =========="

        withCredentials([
            string(credentialsId: 'db-username', variable: 'DB_USERNAME'),
            string(credentialsId: 'db-password', variable: 'DB_PASSWORD')
        ]) {

            sh """
                export IMAGE_NAME=${IMAGE_NAME}
                export IMAGE_TAG=${IMAGE_TAG}

                export DB_USERNAME=${DB_USERNAME}
                export DB_PASSWORD=${DB_PASSWORD}

                docker compose -f ${COMPOSE_FILE} up -d
            """

        }
    }
}
        stage('Docker Cleanup') {

            steps {

                echo "========== CLEANUP =========="

                sh '''
                    docker image prune -f
                '''
            }

        }

    }

    post {

        success {

            echo "======================================="
            echo "Deployment Successful"
            echo "Docker Image : ${DOCKER_IMAGE}"
            echo "======================================="

        }

        failure {

            echo "======================================="
            echo "Deployment Failed"
            echo "======================================="

        }

        always {

            echo "Pipeline Finished"

        }

    }

}
