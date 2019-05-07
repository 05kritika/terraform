title 'infra test cases'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)


AWS_REGION = params['region']['value']
#AVAILABILTY_ZONE = params['availability_zone']['value']

VPC_ID = params['vpc_id']['value']
DHCP_OPTIONS_ID = params['dhcp_id']['value']

INTERNET_GATEWAY = params['internet_gateway']['value']
PUBLIC_ROUTE_TABLE = params['public-route-table']['value']
PUBLIC_SUBNET_ID = params['public-subnet_id']['value']

NAT_GATEWAY = params['nat_gateway']['value']
PRIVATE_ROUTE_TABLE = params['private-route-table']['value']
PRIVATE_SUBNET_ID = params['private-subnet_id']['value']

INSTANCE_ADDRESS = params['aws_instance_public_dns']['value']
INSTANCE_ID = params['instance_id']['value']
INSTANCE_TYPE = params['instance_type']['value']

AMI_ID = params['ami_id']['value']
EBS_VOLUME = params['ebs_root_device']['value']

EC2_SECURITY_GROUP = params['ec2_security_group']['value']
EC2_SECURITY_GROUP_ID = params['ec2_security_group_id']['value']

# execute test
#
 describe aws_vpc(VPC_ID) do
 # it { should be_default }
  its ('vpc_id') { should eq VPC_ID }
  its ('instance_tenancy') { should eq 'default' }
  its ('state') { should eq 'available' }
  its('cidr_block') { should cmp '10.0.0.0/16' }
  its ('dhcp_options_id') { should eq DHCP_OPTIONS_ID }

end
 describe aws_subnets.where( PUBLIC_SUBNET_ID) do
  it { should exist }
  its ('states') {should include 'available'}

#  it { should be_mapping_public_ip_on_launch }
#  it { should be_default_for_az}
#  it { should be_assigning_ipv_6_address_on_creation }
#  its('subnet_ids') { should include PUBLIC_SUBNET_ID }
  its('vpc_ids') { should include VPC_ID }
#  its('cidr_blocks') { should include ['10.0.0.0/24'] }
#  its('availability_zone') { should include AVAILABILITY_ZONE}
  its('count') { should be <251 }
end

describe aws_subnets do
#.where( PRIVATE_SUBNET_ID) do
  it { should exist }
  its ('states') {should include 'available'}
#  it { should be_available }
#  it { should be_mapping_public_ip_on_launch }
#  it { should be_default_for_az}
#  it { should be_assigning_ipv_6_address_on_creation }
#  its('subnet_id') { should include PRIVATE_SUBNET_ID }
  its('vpc_ids') { should include VPC_ID }
  its('cidr_blocks') { should include ['10.0.1.0/24'] }
#  its('availability_zone') { should include AVAILABILITY_ZONE}
  its('count') { should be <= 251 }
end

#describe aws_internet_gateway(INTERNET_GATEWAY) do
#  it { should exist }
#end
#describe aws_nat_gateway(NAT_GATEWAY) do
#  it { should exist }
#end


describe aws_route_table(PUBLIC_ROUTE_TABLE) do
  it { should exist }
  its('route_table_id') {should eq PUBLIC_ROUTE_TABLE}
#  its('route_table_ids') {should include (PRIVATE_ROUTE_TABLE).first & (PRIVATE_ROUTE_TABLE).second }
#  its('vpc_id') { should eq VPC_ID }
 # its('routes.count') { should eq 2 }
 # its('associated_with') { should eq PUBLIC_SUBNET }
 # its('propagating_vgws') { should be_empty }

end

describe aws_route_tables do
  it { should exist }
  its('route_table_ids') {should include (PRIVATE_ROUTE_TABLE[0])}
  its('route_table_ids') {should include (PRIVATE_ROUTE_TABLE[1])}
  its('vpc_ids') { should include VPC_ID }
#  its('routes.count') { should eq 2 }
#  its('associations.count') { should eq 1 }
#  its('propagating_vgws') { should be_empty }

end


describe aws_security_group(group_name: EC2_SECURITY_GROUP , vpc_id: VPC_ID) do
  it { should exist }
  its('group_name') { should eq EC2_SECURITY_GROUP }
  #its('description') { should eq 'Used in the terraform' }
  it { should allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
  #it { should allow_in(port: 80, ipv4_range: '0.0.0.0/0') }
#  it { should allow_in(port: 8080, ipv4_range: '0.0.0.0/0') }
  it { should allow_out(port: 0, ipv4_range: '0.0.0.0/0') }

  its('inbound_rules') { should be_a_kind_of(Array) }
  its('inbound_rules.first') { should be_a_kind_of(Hash) }
#  its('inbound_rules.count') { should cmp 3 } # 3 explicit, one implicit
  its('inbound_rules_count') { should cmp 2 }
  its('outbound_rules') { should be_a_kind_of(Array) }
  its('outbound_rules.first') { should be_a_kind_of(Hash) }
  its('outbound_rules.count') { should cmp 1 } # 1 explicit
#  its('outbound_rules_count') { should cmp 1 }
#  its('vpc_id') { should eq VPC_ID }
end

describe aws_ec2_instance(INSTANCE_ID) do
  it {should exist}
  it { should be_running }
  it { should_not have_roles }
  its('instance_type'){should eq INSTANCE_TYPE }
#  its('instance_type') { should eq 't2.micro' }
  its('image_id') { should eq AMI_ID }
  its('vpc_id') { should eq VPC_ID }
  its('subnet_id') { should include (PUBLIC_SUBNET_ID).first || (PUBLIC_SUBNET_ID).second }
  its('security_group_ids') {should include EC2_SECURITY_GROUP_ID}
  its('root_device_type') {should eq 'ebs'}
#  its ()
end

describe aws_ebs_volume(EBS_VOLUME) do
  it { should exist }
#  it { should_not be_encrypted }
#  its ('volume_id') {should eq EBS_VOLUME[{'volume_id'}]}

end
#describe aws_elb(load_balancer_name: ELB_DNS) do
#   it { should exist }
#    its ('load_balancer_name')  { should eq ELB_DNS }
#end
