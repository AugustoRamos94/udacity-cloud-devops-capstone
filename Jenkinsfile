pipeline {
     agent any
     environment {
        registry = "augustoramos94/capstone-project"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
     stages {

          stage('Make') {
              steps {
                  sh 'make all'
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
                    sh 'kube.sh'                    
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
