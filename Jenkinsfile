pipeline {

    agent any


    environment {

        IMAGE_NAME = "ecommerce-backend"

        CONTAINER_NAME = "ecommerce-backend"

        COMPOSE_FILE = "docker-compose.yml"

    }


    stages {


        stage('Checkout Code') {

            steps {

                echo "Cloning repository..."

                checkout scm

            }
        }



        stage('Build Application') {

            steps {

                echo "Building Spring Boot Application..."

                sh './mvnw clean package -DskipTests'

            }
        }




        stage('Build Docker Image') {

            steps {

                echo "Building Docker Image..."

                sh """

                docker build -t ${IMAGE_NAME}:latest .

                """

            }
        }




        stage('Stop Existing Containers') {

            steps {

                echo "Stopping old containers..."

                sh """

                docker compose -f ${COMPOSE_FILE} down || true

                """

            }
        }




        stage('Deploy Application') {

            steps {

                echo "Starting Application using Docker Compose..."

                sh """

                docker compose -f ${COMPOSE_FILE} up -d

                """

            }
        }




        stage('Docker Cleanup') {

            steps {

                echo "Cleaning unused Docker resources..."

                sh """

                docker image prune -f

                """

            }
        }


    }



    post {


        success {

            echo "Deployment Successful 🚀"

        }


        failure {

            echo "Deployment Failed ❌"

        }


        always {

            echo "Pipeline Completed"

        }


    }


}
