provider "aws" {
    region = "eu-central-1"
}

data "aws_availability_zones" "my_zones" {}
data "aws_caller_identity" "current" {}
data "aws_region" "my_regions" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "my_test_vpc" {
  tags = {
    Name = "test"
  }
}

resource "aws_subnet" "test_subnet_1" {
  vpc_id = data.aws_vpc.my_test_vpc.id
  availability_zone = data.aws_availability_zones.my_zones.names[0]
  cidr_block = "10.10.1.0/24"
  tags = {
    Name = "Subnet 1 in ${data.aws_availability_zones.my_zones.names[0]}"
    Account = "Subnet 1 in ${data.aws_caller_identity.current.account_id}"
    Region = data.aws_region.my_regions.description
  }
}

resource "aws_subnet" "test_subnet_2" {
  vpc_id = data.aws_vpc.my_test_vpc.id
  availability_zone = data.aws_availability_zones.my_zones.names[0]
  cidr_block = "10.10.2.0/24"
  tags = {
    Name = "Subnet 2 in ${data.aws_availability_zones.my_zones.names[1]}"
    Account = "Subnet 2 in ${data.aws_caller_identity.current.account_id}"
    Region = data.aws_region.my_regions.description
  }
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.my_zones.names
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region_name" {
  value = data.aws_region.my_regions.name
}

output "aws_region_description" {
  value = data.aws_region.my_regions.description
}

output "aws_vpcs_ids" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "aws_test_vpc_id" {
  value = data.aws_vpc.my_test_vpc.id
}

output "aws_test_vpc_cidr" {
  value = data.aws_vpc.my_test_vpc.cidr_block
}