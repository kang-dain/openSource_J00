pipeline {
    agent any
    environment {
        PROJECT_ID = 'spheric-method-442206-d2'
        CLUSTER_NAME = 'kube'
        LOCATION = 'asia-northeast3-a'
        DOCKER_IMAGE = 'daain/open_j00'
        GITHUB_CREDENTIALS = 'github-token'
        DOCKER_CREDENTIALS = 'dockerhub-credentials'
        GKE_CREDENTIALS = 'gke'
    }
    stages {
        stage("Checkout code") {
            steps {
                script {
                    // GitHub에서 소스 코드 클론
                    checkout([$class: 'GitSCM',
                        branches: [[name: '*/master']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/kang-dain/open_J00.git',
                            credentialsId: "${GITHUB_CREDENTIALS}"
                        ]]
                    ])
                }
            }
        }
        stage("Build image") {
            steps {
                script {
                    // Docker 이미지 빌드
                    app = docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    // Docker Hub에 푸시
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_CREDENTIALS}") {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage("Authenticate with GKE") {
            steps {
                script {
                    // GKE 인증 및 클러스터 설정
                    withCredentials([file(credentialsId: "${GKE_CREDENTIALS}", variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh """
                            gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                            gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${LOCATION} --project ${PROJECT_ID}
                        """
                    }
                }
            }
        }
        stage("Deploy to Kubernetes") {
            steps {
                script {
                    // Kubernetes에 배포
                    sh """
                        kubectl apply -f deployment.yaml
                        kubectl rollout status deployment/openj00-deployment
                    """
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline completed"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
