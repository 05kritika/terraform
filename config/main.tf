##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {  
  region     					=		 "us-west-2"
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

##################################################################################
# RESOURCES
##################################################################################

module "vpc" {
  source 						=	 	"./../modules"  
  cidr 							=	 	"${var.network_address_space}"    
  public_subnet_count			=		"${var.public_subnet_count}"
  create_private_subnets		=		"${var.create_private_subnets}"
  private_subnet_count			=		"${var.private_subnet_count}"
  tags{
	"Name" 						=		"terraform testing"
  }
}