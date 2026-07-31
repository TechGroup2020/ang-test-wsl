
pipeline {
    agent any

    tools {
        // Name of the Node.js tool configured in Jenkins Global Tool Configuration
        nodejs 'Node22' 
    }

    environment {
        // Keeps npm logs quiet during the build
        npm_config_loglevel = 'silent'
    }

    stages {
        stage('Checkout Git') {
            steps {
                dir('/opt/HelloWrld-main'){
                    sh "pwd"
                    git branch: 'main', 
                    credentialsId: 'github-token', 
                    url: 'https://github.com/TechGroup2020/ang-test-wsl.git'
                    }
        
            }
        }
        stage('Container Cofig') {
            steps {
                dir('/opt/HelloWrld-main'){
                script {
                    // Check if container 'tomct3' exists (running or stopped)
                    def containerExists = sh(
                        script: "docker ps -a -q -f name=^tomct3\$", 
                        returnStatus: true
                    ) == 0 && sh(script: "docker ps -a -q -f name=^tomct3\$", returnStdout: true).trim() != ""

                    if (containerExists) {
                        echo "Container 'tomct3' exists. Checking status..."
                        
                        // Check if the container is currently running
                        def isRunning = sh(
                            script: "docker ps -q -f name=^tomct3\$", 
                            returnStdout: true
                        ).trim() != ""

                        if (!isRunning) {
                            echo "Container 'tomct3' is stopped. Starting container..."
                            sh "docker start tomct3"
                        } else {
                            echo "Container 'tomct3' is already running."
                        }

                        echo "Copying dist folder..."
                       // sh "docker cp /opt/HelloWrld-main/dist/ tomct3:/usr/local/tomcat/webapps/"
                        
                    } else {
                        echo "Container 'tomct3' does not exist. Checking for image 'tomcat1'..."
                        
                        // Check if image 'tomcat1' exists locally
                        def imageExists = sh(
                            script: "docker images -q tomcat1", 
                            returnStatus: true
                        ) == 0 && sh(script: "docker images -q tomcat1", returnStdout: true).trim() != ""

                        if (!imageExists) {
                            echo "Image 'tomcat1' not found. Building image from Dockerfile..."
                            sh "docker build -t tomcat1 ."
                        } else {
                            echo "Image 'tomcat1' already exists."
                        }

                        echo "Creating and starting container 'tomct3'..."
                        sh "docker run -d --name tomct3 -p 9090:9090 tomcat1"
                        sh "docker network connect network3 tomct3 "

                        echo "Copying dist folder to newly created container..."
                       // sh "docker cp /opt/HelloWrld-main/dist/ tomct3:/usr/local/tomcat/webapps/"
                    }
                }
            }
        }
        }
        stage('Build') {
            steps {
                dir('/opt/HelloWrld-main'){
                    sh "rm -rf dist"
                    sh 'npm install'
                    //sh 'npm run build'
                    //sh "ng build --base-href /hello-world/"
                    sh "ng build"
                    sh "docker cp /opt/HelloWrld-main/dist/ tomct3:/usr/local/tomcat/webapps/"
                }
        
            }
        }
        stage('Deploy') {
            steps {
                dir('/opt/HelloWrld-main'){
                    sh "docker cp /opt/HelloWrld-main/dist/*/ tomct3:/usr/local/tomcat/webapps/"
                }
        
            }
        }
      stage('DCGC') {
            steps {
                dir('/opt/'){
                    sh "rm -rf  HelloWrld-main HelloWrld-main@tmp"
                }
        
            }
        }
        
    }
}

