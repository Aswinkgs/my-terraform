pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:Aswinkgs/my-terraform.git',
                    credentialsId: 'github-ssh-key'
            }
        }

        stage('Terraform Provision') {
            steps {
                dir('terraform') {
                    sh '''
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('Docker') {
                    sh '''
                    docker build -t myflaskapp:latest .
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop myapp || true
                docker rm myapp || true
                docker run -d -p 5000:5000 --name myapp myflaskapp:latest
                '''
            }
        }

        stage('Ansible Configuration') {
            steps {
                dir('ansible') {
                    sh '''
                    ansible-playbook -i hosts.ini setup-playbook.yml
                    '''
                }
            }
        }
    }
}
