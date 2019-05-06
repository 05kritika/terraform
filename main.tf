## VARIABLES ##

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default = "Testing"
}

## PROVIDERS ##

provider "aws" {
  access_key = "AKIAJKOSIUHKDCYM4J7Q"
  secret_key = "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"
  region     = "us-east-1"
}


## RESOURCES ##

resource "aws_instance" "nginx" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"

  tags {
    Name = "nginx"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.nginx.public_ip} > ip_address.txt"
  }

  provisioner "remote-exec" {
    inline = [
       "sudo apt-get install nginx -y",
       "sudo systemctl start nginx"
    ]
  }
}

## OUTPUT ##

output "aws_instance_public_dns" {
  value = "${aws_instance.nginx.public_dns}"
}
