variable "cidr" {
  description 	=	 	"The CIDR block for the VPC"
  default     	=	 	""
}

variable "tags" {
  description 	=	 	"A map of tags to add to all resources"  
  default     	=	 	{}
}

variable "public_subnet_count" {
  description = 		"number of public subnets required"
  default     = 		"2"
}

variable "create_private_subnets" {
  description 	=	 	"Set to false to create only public subnets."  
  default     	=	 	false
}

variable "private_subnet_count" {
  description = 		"number of private subnets required"
  default     = 		"3"
}

variable "nat_high_availability" {
  description = 		"number of private subnets required"
  default     = 		true
}

variable "nat_high_availability_count" {
  description = 		"number of private subnets required"
  default     = 		"2"
}
variable "private_key_path" {
  default = "/home/ubuntu/config/Continuous-infra.pem"
}
variable "key_name" {
  default = "Continuous-infra"
}

variable "ami" {
  description = "ubuntu ami"
  default     = "ami-0bbe6b35405ecebdb"

}

variable "instance_type" {
  default = "t2.micro"

}
