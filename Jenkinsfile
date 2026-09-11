pipeline {
    agent any

    environment {
        PATH = "${HOME}/bin:${PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:Aswinkgs/my-terraform.git',
                    credentialsId: 'github-ssh-key'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                    mkdir -p $HOME/bin

                    if ! command -v terraform >/dev/null 2>&1; then
                        echo "Installing Terraform..."

                        cd /tmp

                        curl -LO https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_linux_amd64.zip

                        unzip -o terraform_1.13.3_linux_amd64.zip

                        mv terraform $HOME/bin/terraform

                        chmod +x $HOME/bin/terraform

                        rm -f terraform_1.13.3_linux_amd64.zip
                    fi

                    terraform version
                '''
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
