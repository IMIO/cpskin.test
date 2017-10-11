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
                export IMAGENUMBER=`date +%Y%m%d`-${BUILD_NUMBER}
                docker tag docker-staging.imio.be/cpskin.test:latest docker-staging.imio.be/cpskin.test:$IMAGENUMBER
                docker push docker-staging.imio.be/cpskin.test
                docker rmi docker-staging.imio.be/cpskin.test:latest
                docker rmi docker-staging.imio.be/cpskin.test:$IMAGENUMBER
            '''
        }
    }
}
