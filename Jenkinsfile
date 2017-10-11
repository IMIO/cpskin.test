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
            docker tag -f docker-staging.imio.be/base:latest docker-staging.imio.be/base:`date +%Y%m%d`-${BUILD_NUMBER}
            sh 'export IMAGENUMBER=`date +%Y%m%d`-${BUILD_NUMBER}'
            sh 'docker tag -f docker-staging.imio.be/cpskin.test:latest docker-staging.imio.be/base:$IMAGENUMBER'
            sh 'docker push docker-staging.imio.be/base'
            sh 'docker rmi docker-staging.imio.be/cpskin.test:latest'
            sh 'docker rmi docker-staging.imio.be/cpskin.test:$IMAGENUMBER'
        }
    }
}
