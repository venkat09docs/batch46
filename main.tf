terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
 provider  "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
    ami   =   "ami-025b4b7b37b743227"
    instance_type           = "t2.micro"
    key_name = "cw_key"
    vpc_security_group_ids = [aws_security_group.webserver_sg.id]
    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
        EC2_AVAIL_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)
        echo "<h1>Hello World from $(hostname -f) in AZ $EC2_AVAIL_ZONE </h1>" > /var/www/html/index.html
    EOF

    tags = {
      Name = "WebServer"
      Environment = "Development"
    }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH Protocol"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP Protocol"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Webserver SG"
  }
}
