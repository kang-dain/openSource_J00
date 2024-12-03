node {
    def app

    stage('Clone repository') {
        // GitHub Personal Access Token을 사용하는 자격 증명 지정
        withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
            // GitHub 인증을 사용하여 리포지토리 클론
            git url: 'https://github.com/kang-dain/open_J00.git', branch: 'master', credentialsId: 'github-token'
        }
    }

    stage('Build image') {
        // Docker 이미지 빌드
        app = docker.build("daain/open_j00")
    }

    stage('Push image') {
        script {
            // Docker Hub에 로그인
            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }
    }

    stage('Authenticate with GKE') {
        script {
            // GKE 인증 및 클러스터 설정
            withCredentials([file(credentialsId: 'gke', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                sh """
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                    gcloud container clusters get-credentials kube --zone asia-northeast3-a --project spheric-method-442206-d2
                """
            }
        }
    }

    stage('Deploy to Kubernetes') {
        script {
            // Kubernetes에 배포
            sh """
                kubectl apply -f deployment.yaml
                kubectl rollout status deployment/openj00-deployment
            """
        }
    }
}
