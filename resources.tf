resource "aws_instance" "demo" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data              = <<-EOF
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
    Name        = var.instance_tags["Name"]
    Environment = var.instance_tags["Environment"]
    Owner       = var.instance_tags["Owner"]
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH Protocol"
    from_port   = var.sg_ports[1]
    to_port     = var.sg_ports[1]
    protocol    = "tcp"
    cidr_blocks = [var.sg_cidr]
  }

  ingress {
    description = "HTTP Protocol"
    from_port   = var.sg_ports[2]
    to_port     = var.sg_ports[2]
    protocol    = "tcp"
    cidr_blocks = [var.sg_cidr]
  }

  egress {
    from_port   = var.sg_ports[0]
    to_port     = var.sg_ports[0]
    protocol    = "-1"
    cidr_blocks = [var.sg_cidr]
  }

  tags = {
    Name = "Webserver SG"
  }
}
