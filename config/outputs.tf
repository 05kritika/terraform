output "vpc_id" {
  value 	=	 "${module.vpc.vpc_id}"
}
output "aws_instance_public_dns" {
  value = "${module.vpc.aws_instance_public_dns}"
}
