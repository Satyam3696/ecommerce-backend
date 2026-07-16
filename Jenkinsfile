pipeline {

    agent any

    environment {
        APP_NAME      = "ecommerce-backend"
        IMAGE_NAME    = "ecommerce-backend"
        IMAGE_TAG     = "${BUILD_NUMBER}"
        DOCKER_IMAGE  = "${IMAGE_NAME}:${IMAGE_TAG}"
        COMPOSE_FILE  = "docker-compose.yml"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "========== CHECKOUT CODE =========="
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                echo "========== MAVEN BUILD =========="
                sh '''
                    chmod +x mvnw
                    ./mvnw clean package -DskipTests
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "========== BUILD DOCKER IMAGE =========="

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
                    export IMAGE_NAME=${IMAGE_NAME}
                    export IMAGE_TAG=${IMAGE_TAG}

                    docker compose -f ${COMPOSE_FILE} down || true
                """
            }
        }

        stage('Deploy Application') {
            steps {
                echo "========== DEPLOY APPLICATION =========="

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

        stage('Verify Deployment') {
            steps {
                echo "========== VERIFY DEPLOYMENT =========="

                sh '''
                    echo "========== RUNNING CONTAINERS =========="
                    docker ps

                    echo "========== BACKEND LOGS =========="
                    docker logs ecommerce-backend --tail 50 || true

                    echo "========== MYSQL LOGS =========="
                    docker logs mysql-container --tail 30 || true
                '''
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
            echo "PIPELINE SUCCESSFUL"
            echo "Application : ${APP_NAME}"
            echo "Docker Image: ${DOCKER_IMAGE}"
            echo "======================================="
        }

        failure {
            echo "======================================="
            echo "PIPELINE FAILED"
            echo "Check Jenkins Console Output"
            echo "======================================="
        }

        always {
            echo "Pipeline Execution Completed"
        }
    }
}
