// Jenkinsfile
pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'your-dockerhub-username/countries-capitals-app'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Test Code Quality') {
            steps {
                script {
                    // Проверяем синтаксис Python
                    sh 'python -m py_compile Capital_Country.py'
                    echo 'Синтаксис Python кода проверен успешно'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    // Проверяем, что контейнер запускается
                    def test_container = docker.image("${DOCKER_IMAGE}").run('-it -d --name test-container')
                    sleep(time: 10, unit: 'SECONDS') // Даем время на запуск
                    // Проверяем, что контейнер работает
                    sh 'docker ps | grep test-container'
                    // Останавливаем тестовый контейнер
                    sh 'docker stop test-container'
                    sh 'docker rm test-container'
                    echo 'Docker контейнер прошел базовое тестирование'
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}").push('latest')
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Очистка тестовых контейнеров на всякий случай
            sh 'docker rm -f test-container || true'
            cleanWs()
        }
        success {
            echo '✅ Docker образ успешно собран и отправлен в registry!'
            echo "📦 Образ: ${DOCKER_IMAGE}:latest"
        }
        failure {
            echo '❌ Сборка или тестирование завершились ошибкой!'
        }
    }
}