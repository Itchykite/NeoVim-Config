pipeline {
    agent any

    stages {
        stage('Clone & Modify') {
            steps {
                git credentialsId: 'github-token', url: 'https://github.com/Itchykite/NeoVim-Config.git', branch: 'main'

                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        git config user.email "jenkins@yourdomain.com"
                        git config user.name "Jenkins Bot"
                        git add .
                        git commit -m "Automatyczna aktualizacja przez Jenkins" || echo "Brak zmian do zakomitowania"
                        git remote set-url origin https://${GIT_USER}:${GIT_PASS}@github.com/Itchykite/NeoVim-Config.git
                        git push origin main
                    '''
                }
            }
        }
    }
}
