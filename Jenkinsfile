node {
	def app
	stage('Clone repository') {
		git 'https://github.com/kang-dain/open_J00.git'

	}
	stage('Build image') {
		app = docker.build("daain/test")
	}
	stage('Test image') {
		app.inside {
			sh 'make test'
		}
	}
	stage('Push image') {
		docker.withRepository('https://registry.hub.docker.com', 'daain') {
			app.push("${env.BUILD_NUMBER}")
			app.push("latest")
		}
	}
}
