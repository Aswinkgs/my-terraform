resource "aws_instance" "Myapp"{
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.small"
    key_name = "devops-project"
    security_groups = [aws_security_group.my_sg.name]

user_data = <<-EOF
              #!/bin/bash
              export DEBIAN_FRONTEND=noninteractive
              sudo apt-get update -y

              # Install Docker
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu

              # Install Jenkins
              sudo apt-get install -y openjdk-11-jdk
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt-get update -y
              sudo apt-get install -y jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF


    tags = {
        Name = "Myproject_app"
    }
}