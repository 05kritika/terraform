variable "cidr" {
  description   =               "The CIDR block for the VPC"
  default       =               ""
}

variable "public_subnet_count" {
  description =                 "number of public subnets required"
  default     =                 "2"
}

variable "create_private_subnets" {
  description   =               "Set to false to create only public subnets."
  default       =               false
}

variable "private_subnet_count" {
  description =                 "number of private subnets required"
  default     =                 "3"
}

variable "nat_high_availability" {
  description =                 "whether every private subnet needs a different NAT GW or all the subnets will use a single gateway"
  default     =                 true
}

variable "tags" {
  description   =               "A map of tags to add to all resources"
  type                  =               "map"
  default       =               {
    Name                =               "test",
        Environment =           "test"
        purpose         =               "test"
        owner           =               "test"
  }
}

variable "private_key_path" {
  default = "/home/ubuntu/kritika-key.pem"
}
variable "key_name" {
  default = "kritika-key"
}

variable "ami" {
  description = "ubuntu ami"
  default     = "ami-0bbe6b35405ecebdb"

}

variable "instance_type" {
  default = "t2.micro"

}
