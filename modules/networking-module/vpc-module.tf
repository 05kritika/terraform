##################################################################################
# DATA
##################################################################################

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_vpc_dhcp_options" "DHCP" {
  domain_name                   =       "${data.aws_region.current.name == "us-east-1" ? "ec2.internal" : format("%s.compute.internal", data.aws_region.current.name)}"
  domain_name_servers           =       ["AmazonProvidedDNS"]
  tags                                          =       "${var.tags}"
  tags                                          =       "${merge(var.tags, map("Name", format("%s-dhcp", lookup(var.tags, "Name"))))}"
}

resource "aws_vpc" "vpc" {
  cidr_block                            =       "${var.cidr}"
  instance_tenancy                      =       "default"
  enable_dns_hostnames          =       "true"
  tags                                          =       "${merge(var.tags, map("Name", format("%s-vpc", lookup(var.tags, "Name"))))}"
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id                                =       "${aws_vpc.vpc.id}"
  dhcp_options_id                       =       "${aws_vpc_dhcp_options.DHCP.id}"
}

resource "aws_internet_gateway" "IGW" {
  vpc_id                                        =       "${aws_vpc.vpc.id}"
  tags                                          =       "${merge(var.tags, map("Name", format("%s-igw", lookup(var.tags, "Name"))))}"
}

resource "aws_subnet" "public_subnets" {
  count                                         =       "${var.public_subnet_count}"
  vpc_id                                =       "${aws_vpc.vpc.id}"
  cidr_block                            =       "${cidrsubnet(var.cidr, 8, count.index + 1)}"
  map_public_ip_on_launch       =       true
  availability_zone                     =       "${element(data.aws_availability_zones.available.names, count.index )}"
  tags                                          =       "${merge(var.tags, map("Name", format("PublicSubnet%d-%s", count.index + 1, lookup(var.tags, "Name"))))}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id                                =       "${aws_vpc.vpc.id}"
  tags                                          =       "${merge(var.tags, map("Name", format("PublicRouteTable-%s", lookup(var.tags, "Name"))))}"
}

resource "aws_route_table_association" "public_route_table_association" {
  count                                 =       "${var.public_subnet_count}"
  subnet_id                             =       "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id                        =       "${aws_route_table.public_route_table.id}"
}

resource "aws_route" "public_subnet_route" {
  route_table_id                =       "${aws_route_table.public_route_table.id}"
  destination_cidr_block    =   "0.0.0.0/0"
  gateway_id                            =   "${aws_internet_gateway.IGW.id}"
}

resource "aws_subnet" "private_subnets" {
  count                                         =       "${(var.private_subnet_count > 0 ) && var.create_private_subnets ? var.private_subnet_count : 0 }"
  vpc_id                                =       "${aws_vpc.vpc.id}"
  cidr_block                            =       "${cidrsubnet(var.cidr, 8, count.index + var.public_subnet_count + 1)}"
  map_public_ip_on_launch       =       false
  availability_zone                     =       "${element(data.aws_availability_zones.available.names, count.index )}"
  tags                                          =       "${merge(var.tags, map("Name", format("PrivateSubnet%d-%s", count.index + 1, lookup(var.tags, "Name"))))}"
}

resource "aws_eip" "nateip" {
  vpc                                           =       true
  count                                         =       "${(var.nat_high_availability && var.create_private_subnets) ? var.private_subnet_count : (var.create_private_subnets ? 1 : 0) }"
  tags                                          =       "${merge(var.tags, map("Name", format("%s-eip%d", lookup(var.tags, "Name"), count.index + 1)))}"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id                         =       "${element(aws_eip.nateip.*.id, count.index)}"
  subnet_id                             =       "${element(aws_subnet.public_subnets.*.id, count.index)}"
  count                                 =       "${(var.nat_high_availability && var.create_private_subnets) ? var.private_subnet_count: (var.create_private_subnets ? 1 : 0)}"
  depends_on                            =       ["aws_internet_gateway.IGW"]
  tags                                          =       "${merge(var.tags, map("Name", format("%s-natgw%d", lookup(var.tags, "Name"), count.index + 1)))}"
}

resource "aws_route_table" "private_route_table" {
  vpc_id                                =       "${aws_vpc.vpc.id}"
  tags                                          =       "${merge(var.tags, map("Name", format("PrivateRouteTable-%s", lookup(var.tags, "Name"))))}"
}

resource "aws_route_table_association" "private_route_table_association" {
  count                                 =       "${var.private_subnet_count}"
  subnet_id                             =       "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id                        =       "${aws_route_table.private_route_table.id}"
}

resource "aws_route" "private_subnet_route" {
  route_table_id                =       "${element(aws_route_table.private_route_table.*.id, count.index)}"
  destination_cidr_block        =       "0.0.0.0/0"
  nat_gateway_id                =       "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                         =       "${(var.nat_high_availability && var.create_private_subnets) ? var.private_subnet_count: (var.create_private_subnets ? 1 : 0)}" 
}

# Nginx security group
resource "aws_security_group" "nginx-sg" {
  name                          =       "nginx_sg"
  vpc_id                        =       "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port                   =       22
    to_port                     =       22
    protocol                    =       "tcp"
    cidr_blocks                 =       ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port                   =       80
    to_port                     =       80
    protocol                    =       "tcp"
    cidr_blocks                 =       ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port                    =      0
    to_port                      =      0
    protocol                     =      "-1"
    cidr_blocks                  =      ["0.0.0.0/0"]
  }

  tags {
    Name                        =       "nginx-security-group"
  }

}
resource "aws_instance" "nginx" {
  ami                           =       "${var.ami}"
  instance_type                 =       "${var.instance_type}"
  subnet_id                     =       "${element(aws_subnet.public_subnets.*.id, count.index)}"
  vpc_security_group_ids        =       ["${aws_security_group.nginx-sg.id}"]
  key_name                      =       "${var.key_name}"

  connection {
    user                        =       "ubuntu"
    private_key                 =       "${file(var.private_key_path)}"
  }

  tags {
    Name                        =       "nginx1"
  }
  
  provisioner "local-exec" {
    command = "echo ${aws_instance.nginx.public_dns} > public_dns.txt"
  }
  provisioner "remote-exec" {
    inline                      = [
                                        "sudo apt-get upgrade -y",
                                        "sudo apt-get update -y",
                                        "sudo apt-get install nginx -y",
                                        "sudo systemctl start nginx"
                                 ]
  }
}

