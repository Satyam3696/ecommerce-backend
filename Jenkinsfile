pipeline {

    agent any


    environment {

        APP_NAME = "ecommerce-backend"

        IMAGE_NAME = "ecommerce-backend"

        IMAGE_TAG = "${BUILD_NUMBER}"

        DOCKER_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"

        COMPOSE_FILE = "docker-compose.yml"

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
                    ./mvnw clean package
                '''

            }
        }




        stage('Build Docker Image') {

            steps {


                echo "========== BUILD DOCKER IMAGE =========="


                sh """

                    docker build \
                    -t ${DOCKER_IMAGE} .

                """


            }
        }





        stage('Stop Existing Containers') {


            steps {


                echo "========== STOP OLD CONTAINERS =========="


                sh """

                    docker compose \
                    -f ${COMPOSE_FILE} down || true

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



                        docker compose \
                        -f ${COMPOSE_FILE} up -d


                    """


                }


            }

        }





        stage('Verify Deployment') {


            steps {


                echo "========== VERIFY DEPLOYMENT =========="


                sh '''

                    echo "Running Containers:"

                    docker ps



                    echo "Backend Logs:"

                    docker logs ecommerce-backend --tail 50

                '''


            }

        }






        stage('Docker Cleanup') {


            steps {


                echo "========== CLEANUP OLD IMAGES =========="


                sh '''

                    docker image prune -f

                '''


            }

        }


    }




    post {


        success {


            echo """

            =====================================

            PIPELINE SUCCESSFUL

            Application : ${APP_NAME}

            Docker Image : ${DOCKER_IMAGE}

            Status : DEPLOYED

            =====================================

            """


        }





        failure {


            echo """

            =====================================

            PIPELINE FAILED

            Check Jenkins Logs

            =====================================

            """


        }





        always {


            echo "Pipeline Execution Completed"


        }


    }

}
