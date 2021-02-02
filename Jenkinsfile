pipeline {
     agent any
     environment {
        registry = "augustoramos94/capstone-project"
        registryCredential = 'dockerid'
        dockerImage = ''
    }
     stages {

         stage('Make setup') {
              steps {
                  sh 'make setup'
              }
         }
         stage('Make install') {
              steps {
                  sh 'make install'
              }
         }
         stage('Lint Files') {
              steps {
                  sh 'make lint'
              }
         }
         stage('Docker Build'){
             steps{
                 script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
             }
         }
         stage('Upload Image') {
            steps {
                script  {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
         stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
        stage('Set Kubernetes Config'){
            steps {
                withAWS(region:'us-west-2',credentials:'aws') {
                    sh 'aws eks --region us-west-2 update-kubeconfig --name kubeClusters'                    
                }
            }
        }
        stage('Deploy K8s'){
            steps{
                sh '''
                    export IMAGE="$registry:$BUILD_NUMBER"
                    sed -ie "s~IMAGE~$IMAGE~g" flask-container.yml
                    kubectl apply -f ./kubernetes
                    '''
            }
        }         
     }
}
