variable "cidr" {
  description   =               "The CIDR block for the VPC"
  default       =               "10.40.0.0/16"
}

variable "public_subnet_count" {
  description =                 "number of public subnets required"
  default     =                 "2"
}

variable "create_private_subnets" {
  description   =               "Set to false to create only public subnets."
  default       =               true
}

variable "private_subnet_count" {
  description =                 "number of private subnets required"
  default     =                 "2"
}

variable "nat_high_availability" {
  description =                 "whether every private subnet needs a different NAT GW or all the subnets will use a single gateway"
  default     =                 false
}

variable "tags" {
  description   =               "A map of tags to add to all resources"
  type                  =               "map"
  default       =               {
    Name                =               "Devops",
        Environment =           "Prod"
        information     =               "Testing"

  }
}
