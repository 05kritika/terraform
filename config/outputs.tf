#output "vpc_id" {
#  value 	=	 "${module.vpc.vpc_id}"
#}
#output "aws_instance_public_dns" {
#  value = "${module.vpc.aws_instance_public_dns}"
#}


output "vpc_id" {
  value ="${module.vpc.vpc_id}"
}

output "dhcp_id" {
  value = "${module.vpc.dhcp_id}"
}

output "internet_gateway" {
  value = "${module.vpc.internet_gateway}"
}


output "public-subnet_id" {
  value = "${module.vpc.public-subnet_id}"
}

output "public-route-table" {
  value = "${module.vpc.public-route-table}"
}


output "private-subnet_id" {
  value = "${module.vpc.private-subnet_id}"
}

#output "eip" {
#  value = "${aws_eip.nateip.}"
#}

output "nat_gateway" {
  value = "${module.vpc.nat_gateway}"
}
output "private-route-table" {
  value = "${module.vpc.private-route-table}"
}

output "ec2_security_group" {
  value = "${module.vpc.ec2_security_group}"

}
output "ec2_security_group_id" {
  value = "${module.vpc.ec2_security_group_id}"

}

output "ami_id" {
  value = "${module.vpc.ami_id}"
}

output "aws_instance_public_dns" {
  value = "${module.vpc.aws_instance_public_dns}"
}

output "instance_id" {
  value = "${module.vpc.instance_id}"
}

output "instance_type" {
  value = "${module.vpc.instance_type}"
}


output "ebs_block_device" {
  value = ["${module.vpc.ebs_block_device}"]
}

output "ebs_root_device" {
  value = ["${module.vpc.ebs_root_device}"]
}

#output "root_device_type" {
#  value = ["${aws_instance.web.root_block_device_type}"]
#}

#output "ebs_volume" {
#  value = ["${aws_instance.web.ebs_volume.id}"]
#}

