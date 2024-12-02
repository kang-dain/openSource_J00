node {
    def app
    stage('Clone repository') {
        git url: 'https://github.com/kang-dain/open_J00.git', branch: 'master'
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

