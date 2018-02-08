pipeline {
    agent any
    triggers {
        pollSCM('*/3 * * * *')
    }
    stages {
        stage('Build') {
            steps {
                sh 'make build'
            }
        }
    }
    post {
        success {
            sh '''
                docker push docker-staging.imio.be/cpskin.test
                docker rmi docker-staging.imio.be/cpskin.test
            '''
        }
    }
}
