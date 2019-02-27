output "vpc_id" {
  value 	=	 "${aws_vpc.vpc.id}"
}
output "aws_instance_public_dns" {
  value = "${aws_instance.nginx.public_dns}"
}
