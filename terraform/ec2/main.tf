provider "aws" {
  region = "us-east-1"  
  
}
 resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins"
  public_key = file("/Users/firasathmohammed/.ssh/id_rsa.pub")
 }

resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins_sg"
  description = "Allow SSH, HTTP, and Jenkins ports"


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "jenkins" {
  ami           = "ami-0e449927258d45bc4"  
  instance_type = "t2.micro"  
  key_name = aws_key_pair.jenkins-key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]             

  tags = {
    Name = "Jenkins-1"
  }
}
