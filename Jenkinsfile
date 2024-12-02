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
}

