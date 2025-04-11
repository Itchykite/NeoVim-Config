pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "registry.gitlab.com/itchykite/neovim-config"  // lub np. DockerHub, Nexus itd.
    }

    stages {

        stage('Checkout') {
            steps {
                git credentialsId: 'github-token', url: 'https://github.com/Itchykite/NeoVim-Config.git', branch: 'main'
            }
        }

        stage('Test') {
            steps {
                echo 'Tu mógłbyś dodać test np. lintera, parsera pliku init.lua itd.'
                sh 'cat init.lua | grep "nvim"'  // przykładowy test
            }
        }

        stage('Modify') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        echo "-- automatyczna aktualizacja przez Jenkins" >> init.lua
                        git config user.email "jenkins@yourdomain.com"
                        git config user.name "Jenkins Bot"
                        git add .
                        git commit -m "Automatyczna aktualizacja przez Jenkins" || echo "Brak zmian"
                        git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/Itchykite/NeoVim-Config.git
                        git push origin main
                    '''
                }
            }
        }

        stage('Build Docker (opcjonalnie)') {
            when {
                expression { fileExists('Dockerfile') }
            }
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        stage('Deploy (opcjonalnie)') {
            when {
                expression { fileExists('Dockerfile') }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'registry-credentials', usernameVariable: 'REG_USER', passwordVariable: 'REG_PASS')]) {
                    sh '''
                        echo "$REG_PASS" | docker login -u "$REG_USER" --password-stdin registry.gitlab.com
                        docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }
    }
}
