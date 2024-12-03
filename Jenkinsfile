pipeline {
    agent any
    environment {
        PROJECT_ID = 'spheric-method-442206-d2'
        CLUSTER_NAME = 'kube'
        LOCATION = 'asia-northeast3-a'
        CREDENTIALS_ID = 'gke'
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE = 'daain/open_j00'
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
                    // Docker 이미지 빌드
                    app = docker.build("daain/open_j00:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    // Docker Hub에 이미지 푸시
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
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
                script {
                    // deployment.yaml 파일 수정
                    sh "sed -i 's|open_j00:latest|${DOCKER_IMAGE}:${env.BUILD_ID}|g' deployment.yaml"
                    
                    // GKE 클러스터에 배포
                    step([
                        $class: 'KubernetesEngineBuilder',
                        projectId: PROJECT_ID,
                        clusterName: CLUSTER_NAME,
                        location: LOCATION,
                        manifestPattern: 'deployment.yaml',
                        credentialsId: CREDENTIALS_ID
                    ])
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
