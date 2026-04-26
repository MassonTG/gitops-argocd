provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "k3s_sg" {
  name = "project-6-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ArgoCD UI
  ingress {
    from_port   = 30088
    to_port     = 30088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "project-6-sg" }
}

resource "aws_instance" "k3s" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "c7i-flex.large"
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y curl
    curl -sfL https://get.k3s.io | sh -
    chmod 644 /etc/rancher/k3s/k3s.yaml
  EOF

  root_block_device {
    volume_size = 20
  }

  tags = { Name = "project-6-argocd" }
}

output "public_ip" {
  value = aws_instance.k3s.public_ip
}