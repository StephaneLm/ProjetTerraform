# Terraform version et provider AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.14"
}

provider "aws" {
  region = "us-east-1"  # Remplacez par la région de votre choix
}

# Créer une paire de clés SSH
resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Créer une instance EC2
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # AMI Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key.key_name

  tags = {
    Name = "Docker-NGINX-PHP"
  }

  vpc_security_group_ids = [aws_security_group.web_sg.id]
}

# Groupe de sécurité pour l'instance
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
