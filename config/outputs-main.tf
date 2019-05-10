output "vpc_id" {
  value         =        "${module.vpc-module.vpc_id}"
}

output "vpc_cidr" {
  value         =        "${module.vpc-module.vpc_cidr}"
}
output "dhcp_id" {
  value = "${module.vpc-module.dhcp_id}"
}

output "internet_gateway" {
  value = "${module.vpc-module.internet_gateway}"
}


output "public-subnet_id" {
  value = "${module.vpc-module.public-subnet_id}"
}

output "public-route-table" {
  value = "${module.vpc-module.public-route-table}"
}


output "private-subnet_id" {
  description = "List of IDs of private subnets"
  value = "${module.vpc-module.private-subnet_id}"
}

#output "eip" {
#  value = "${aws_eip.nateip.}"
#}

output "nat_gateway" {
  value = "${module.vpc-module.nat_gateway}"
}

output "private-route-table" {
  value = "${module.vpc-module.private-route-table}"
}

output "ELB_ID" {
  value = "${module.elb.this_elb_id}"
}

output "ELB_ARN" {
  value = "${module.elb.this_elb_arn}"
}

output "ELB_Name" {
  value = "${module.elb.this_elb_name}"
}

output "ELB_DNS" {
  value = "${module.elb.this_elb_dns_name}"
}

output "ELB_Instances" {
  value = "${module.elb.this_elb_instances}"
}

output "ELB_Security_Group" {
  value = "${module.elb.this_elb_source_security_group_id}"
}

#output "ELB_Security_Group_name" {
#  value = "${module.elb.this_elb_source_security_group_name}"
#}


output "ELB_Zone" {
  value = "${module.elb.this_elb_zone_id}"
}
output "ec2_security_group" {
  value = "${module.vpc-module.ec2_security_group}"

}

output "ec2_security_group_id" {
  value = "${module.vpc-module.ec2_security_group_id}"

}

output "ami_id" {
  value = "${module.vpc-module.ami_id}"
}

output "aws_instance_public_dns" {
  value = "${module.vpc-module.aws_instance_public_dns}"
}
output "instance_id" {
  value = "${module.vpc-module.instance_id}"
}

output "instance_type" {
  value = "${module.vpc-module.instance_type}"
}


output "ebs_block_device" {
  value = ["${module.vpc-module.ebs_block_device}"]
}

output "ebs_root_device" {
  value = ["${module.vpc-module.ebs_root_device}"]
}

