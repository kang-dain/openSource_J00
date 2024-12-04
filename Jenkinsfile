pipeline {
    agent any
    environment {
        PROJECT_ID = 'spheric-method-442206-d2'
        CLUSTER_NAME = 'kube'
        LOCATION = 'asia-northeast3-a'
        CREDENTIALS_ID = 'gke'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build image") {
            steps {
                script {
                    app = docker.build("daain/open_j00:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'daain') {
                        app.push("latest")
                        app.push("${env.BUILD_ID}")
                    }
                }
            }
        }
        stage('Deploy to GKE') {
            when {
                branch 'master'
            }
            steps {
                sh "sed -i 's/open_j00:latest/open_j00:${env.BUILD_ID}/g' deployment.yaml"
                step([
                    $class: 'KubernetesEngineBuilder',
                    projectId: env.PROJECT_ID,
                    clusterName: env.CLUSTER_NAME,
                    location: env.LOCATION,
                    manifestPattern: 'deployment.yaml',
                    credentialsId: env.CREDENTIALS_ID
                ])
            }
        }
    }    
}
