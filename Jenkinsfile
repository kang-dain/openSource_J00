node {
    def app
    stage('Clone repository') {
        git credentialsId: 'github-credentials', url: 'https://github.com/kang-dain/open_J00.git'
    }

    stage('Build image') {
        app = docker.build("daain/open_j00")
    }

    stage('Push image') {
        script {
            docker.withRegistry('https://registry.hub.docker.com', 'daain') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }
    }
}

