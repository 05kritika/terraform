##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region						= "us-west-2"
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

##################################################################################
# RESOURCES
##################################################################################

module "label1" {
  source						= "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace                                             = "SANY"
  environment                                           = "UAT"
  stage                                                 = ""
  name                                                  = ""
  attributes                                            = []
  delimiter                                             = "-"

  label_order                                           = ["namespace", "environment", "stage", "attributes"]

  tags = {
    "owner"                                             = "kritika"
  }

  additional_tag_map = {
    propagate_at_launch 				= "true"
  }
}


module "vpc-module" {
  source                                                = "/home/ubuntu/CI-IT/modules/networking-module/"
  cidr                                                  = "${var.cidr}"
  public_subnet_count                                   = "${var.public_subnet_count}"
  create_private_subnets                                = "${var.create_private_subnets}"
  private_subnet_count                                  = "${var.private_subnet_count}"
  nat_high_availability                                 = "${var.nat_high_availability}"
  tags                                                  = "${module.label1.tags}"
}
module "elb" {
  source                                                = "/home/ubuntu/CI-IT/modules/elb-module/"

  name                                                  = "kritika"

  subnets                                               = "${module.vpc-module.public-subnet_id}"

  security_groups                                       = ["${module.elb_sg.this_security_group_id}"]
  internal                                              = false

  listener = [
    {
      instance_port                                     = "80"
      instance_protocol                                 = "TCP"
      lb_port                                           = "80"
      lb_protocol                                       = "TCP"
    }
  ]

  health_check = [
    {
      target                                             = "TCP:80"
      interval                                           = 30
      healthy_threshold                                  = 2
      unhealthy_threshold                                = 2
      timeout                                            = 5
    },
  ]

  instances                                              = ["${module.vpc-module.instance_id}"]
  cross_zone_load_balancing                              = true
  idle_timeout                                           = 400
  connection_draining                                    = true
  connection_draining_timeout                            = 400

  // Uncomment this section and set correct bucket name to enable access logging
  //  access_logs = [
  //    {
  //      bucket 					= "my-access-logs-bucket"
  //    },
  //  ]

	  tags                                          = "${module.label1.tags}"
}

module "web_application_sg" {
  source                                                = "github.com/terraform-aws-modules/terraform-aws-security-group"
  vpc_id                                                = "${module.vpc-module.vpc_id}"
  name                                          	= "${format("%s-%s-web_application_sg", module.label1.namespace , module.label1.environment)}"
  description                                   	= "Security group for the services"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                				= 9095
      to_port                  				= 9095
      protocol                 				= "tcp"
      description              				= "ELB sg rule"
      source_security_group_id 				= "${module.elb_sg.this_security_group_id}"
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      rule        					= "all-all"
      cidr_blocks 					= "0.0.0.0/0"
    }
  ]

  tags                                          	= "${module.label1.tags}"
}

module "elb_sg" {
  source                                                = "github.com/terraform-aws-modules/terraform-aws-security-group"
  vpc_id                                                = "${module.vpc-module.vpc_id}"
  name                                          	= "${format("%s-%s-web_application_sg", module.label1.namespace , module.label1.environment)}"
  description                                   	= "Security group for the elb"

   computed_ingress_with_cidr_blocks = [

    {
      from_port   					= 80
      to_port     					= 80
      protocol    					= "tcp"
      description 					= "web service access rule"
      cidr_blocks 					= "0.0.0.0/0"
    }
  ]

  number_of_computed_ingress_with_cidr_blocks 		= 1

  egress_with_cidr_blocks = [
    {
      rule        					= "all-all"
      cidr_blocks 					= "0.0.0.0/0"
    }
  ]

  tags                                          	= "${module.label1.tags}"
}
