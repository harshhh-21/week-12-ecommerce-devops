pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Compose') {
            steps {
                withCredentials([file(
                    credentialsId: 'ecommerce-env-file',
                    variable: 'ENV_FILE'
                )]) {
                    sh '''
                        set -eu
                        docker-compose --env-file "$ENV_FILE" \
                          -f docker/docker-compose.yml config --quiet
                        echo "Compose configuration is valid."
                    '''
                }
            }
        }

        stage('Backend Test') {
            steps {
                dir('app/backend') {
                    sh '''
                        set -eu
                        npm ci
                        npm test
                    '''
                }
            }
        }

        stage('Build Images') {
            steps {
                withCredentials([file(
                    credentialsId: 'ecommerce-env-file',
                    variable: 'ENV_FILE'
                )]) {
                    sh '''
                        set -eu
                        docker-compose --env-file "$ENV_FILE" \
                          -f docker/docker-compose.yml build
                    '''
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh '''
                    set -eu
                    trivy image --download-db-only
                    trivy image --no-progress \
                      --severity HIGH,CRITICAL \
                      --exit-code 1 docker_backend:latest
                    trivy image --no-progress \
                      --severity HIGH,CRITICAL \
                      --exit-code 1 docker_frontend:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([file(
                    credentialsId: 'ecommerce-env-file',
                    variable: 'ENV_FILE'
                )]) {
                    sh '''
                        set -eu
                        docker-compose --env-file "$ENV_FILE" \
                          -f docker/docker-compose.yml up -d
                    '''
                }
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                    set -eu

                    healthy=0
                    for attempt in $(seq 1 12); do
                        if curl -fsS \
                          http://127.0.0.1:3001/api/v1/health/ \
                          -o /tmp/week12-health.json; then
                            healthy=1
                            break
                        fi
                        sleep 5
                    done

                    test "$healthy" -eq 1
                    cat /tmp/week12-health.json
                    grep -q '"status":"ok"' /tmp/week12-health.json
                    curl -fsSI http://127.0.0.1:5174
                '''
            }
        }
    }

    post {
        always {
            sh '''
                docker ps --format 'table {{.Names}}\\t{{.Status}}\\t{{.Ports}}' || true
            '''
        }
        success {
            echo 'Week 12 CI/CD pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Review the stage logs before retrying.'
        }
    }
}
