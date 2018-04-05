pipeline {
    agent any
    triggers {
        cron('30 2 * * *')
    }
    stages {
        stage('Build') {
            parallel {
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
        }
        stage('Push image to registry') {
            steps {
                sh '''
                    docker push docker-staging.imio.be/iasmartweb/test
                    docker rmi $(docker images -q docker-staging.imio.be/iasmartweb/test)
                '''
            }
        }
    }
}
