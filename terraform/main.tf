provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "ami" {
  name = "/nginx/latest-ami"
}

resource "aws_security_group" "web" {
  name = "nginx-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t3.micro"
  key_name      = var.key_name

  security_groups = [aws_security_group.web.name]

  tags = {
    Name = "nginx-server"
  }
}
