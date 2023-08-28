pipeline {
    agent any
    stages {
        stage('Deploy to Kubernetes Cluster') {
            steps {
                echo 'Deploy to Kubernetes Cluster'
                sh "./deploy.sh ${params.ENVIRONMENT}"
            }
        }

    }
}