pipeline {
    agent any
    triggers {
        pollSCM('*/3 * * * *')
    }
    stages {
        stage('Build uid 1000') {
            steps {
                sh 'make build'
            }
        }
        stage('Build uid 110 (IMIO Jenkins)') {
            steps {
                sh 'make jenkins-build'
            }
        }
    }
    post {
        success {
            sh '''
                docker push docker-staging.imio.be/iasmartweb/test
                docker rmi $(docker images -q docker-staging.imio.be/iasmartweb/test)
            '''
        }
    }
}
