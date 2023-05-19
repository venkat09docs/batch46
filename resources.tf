data "aws_ami" "amazon_linux_2" {
    most_recent  = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*"]
    }
}

resource "aws_instance" "demo" {

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data              = file("scripts/httpd.sh")

  tags = {
    Name        = "${var.instance_tags["Name"]}"
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

resource "null_resource" "provisioners" {
    depends_on = [
        aws_instance.demo
    ]

    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("./cw_key.pem")
        host     = aws_instance.demo.public_ip
    }

    provisioner "file" {
        source      = "files/"
        destination = "/tmp/"
    }

    provisioner "remote-exec" {
      inline = [
        "sleep 60",
        "sudo cp /tmp/index.html /var/www/html/"
      ]
    }
}
