// Variable Data Types

// string_var="Simple String"
variable "string_var" {
  default = "Simple String"
  type    = string
}

// Number Data Type
// ssh_port=22
variable "ssh_port" {
  default = 22
  type    = number
}

// Boolean Data Type
// simple_boolean=true
variable "simple_boolean" {
  default = true
  type    = bool
}

// List Data Type
// sg_ports=[22,80,443]
variable "simple-list" {
  type    = list(any)
  default = [22, 80, 8080, 443]
}

// Map Data Type
// { key1 = "val1", key2 = "val2", key3 = "val3"    }
variable "simple-map" {
  type = map(any)
  default = {
    name    = "RnsTech"
    Trainer = "Venkat"
  }
}

locals {
    institute = "Name=${var.simple-map["name"]}, Trainer=${var.simple-map["Trainer"]}"
}

resource "null_resource" "sample1" {
  provisioner "local-exec" {
    command = "echo String = ${var.string_var} \t Number = ${var.ssh_port} \t Boolean = ${var.simple_boolean}"
  }

  provisioner "local-exec" {
    command = "echo Port-1 = ${var.simple-list[0]} \t Port-2 = ${var.simple-list[1]} \t Port-3 = ${var.simple-list[2]} \t Port-4 = ${var.simple-list[3]}"
  }

  provisioner "local-exec" {
    command = "echo ${local.institute}"
  }
}
