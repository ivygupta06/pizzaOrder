pipeline {
    agent any

    tools {
        nodejs 'node18'
        jdk 'jdk17'
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        S3_BUCKET = 'devopssampleapp'
        APP_NAME = 'FrontendSampleApp'
    }

    stages {

        stage('Checkout') {
            steps {
                deleteDir()
                git branch: 'main',
                    url: 'https://github.com/TejasG30/my-pizza-online-order.git',
                    credentialsId: 'github-pat'
            }
        }

        stage('Validate') {
            steps {
                sh 'ls -l'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install --legacy-peer-deps'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('sonarqube') {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=frontend-app \
                        -Dsonar.projectName=Frontend-App \
                        -Dsonar.sources=src
                        """
                    }
                }
            }
        }
    }
}
