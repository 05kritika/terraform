variable "network_address_space" {
  default = "10.0.0.0/16"
}

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
  default     	=	 	true
}

variable "private_subnet_count" {
  description = 		"number of private subnets required"
  default     = 		"2"
}
