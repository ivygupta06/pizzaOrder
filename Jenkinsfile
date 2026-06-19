pipeline {
    agent any


    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        S3_BUCKET = 'devopssampleapp-frontend'
        APP_NAME = 'my-pizza-order-online'
    }

    stages {

        stage('Checkout') {
    steps {
        git branch: 'main',
            url: 'https://github.com/ivygupta06/pizzaOrder.git',
            credentialsId: 'guthub-pat'
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

        stage('Build Angular App') {
            steps {
                sh '''
                NODE_OPTIONS=--openssl-legacy-provider npx ng build --configuration production
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform -chdir=terraform/site init'
            }
        }

        stage('Terraform Apply') {
            steps {
        script {

	    sh '''
            terraform -chdir=terraform/site init

            terraform -chdir=terraform/site apply -auto-approve || true
            '''
        }
    }
        }

        stage('Deploy to S3') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'ap-south-1') {
                    sh '''
                    aws s3 sync dist/$APP_NAME/ s3://$S3_BUCKET --delete
                    '''
                }
            }
        }
    }
}
