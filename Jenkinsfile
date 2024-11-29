node {
	def app
	stage('Clone repository') {
		git url: 'https://github.com/kang-dain/open_J00.git', credentialsId: 'github-credentials'

	}
	stage('Build image') {
		app = docker.build("daain/test")
	}
	stage('Test image') {
		app.inside {
			sh 'npm test'
		}
	}
	stage('Push image') {
		docker.withRepository('https://registry.hub.docker.com', 'daain') {
			app.push("${env.BUILD_NUMBER}")
			app.push("latest")
		}
	}
}
