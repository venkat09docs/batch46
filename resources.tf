resource "aws_instance" "demo" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data              = file("scripts/httpd.sh")

  tags = {
    Name        = var.instance_tags["Name"]
    Environment = var.instance_tags["Environment"]
    Owner       = var.instance_tags["Owner"]
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow SSH inbound traffic"

  dynamic "ingress" {
      for_each = var.sg_ports_ingress
      content {
          from_port = ingress.value
          to_port = ingress.value
          protocol = "tcp"
          cidr_blocks = [var.sg_cidr]
      }
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = "-1"
    cidr_blocks = [var.sg_cidr]
  }

  tags = {
    Name = "Webserver SG"
  }
}
