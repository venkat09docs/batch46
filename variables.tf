variable "region" {
  default = "ap-south-1"
  type    = string
}

variable "ami_id" {
  default = "ami-025b4b7b37b743227"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {
  default = "cw_key"
}

variable "instance_tags" {
  type = map(any)
  default = {
    Name        = "WebServer"
    Environment = "Development"
    Owner       = "Rnstech"
  }
}

variable "sg_ports" {
  default = [0, 22, 80]
  type    = list(any)
}

variable "sg_cidr" {
  default = "0.0.0.0/0"
}
