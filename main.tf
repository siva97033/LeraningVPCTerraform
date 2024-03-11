resource "aws_vpc" "main" {
 cidr_block = var.VPC
tags = merge(
    var.tags,
    {
      Name = "TerraformVPC"
    },
  )
 
 }



resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}



resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
tags = merge(
    var.tags,
    {
      Name = "TerraformIGW"
    },
  )
}


resource "aws_nat_gateway" "NAT" {
  #count = length(var.public_subnet_cidrs)

  allocation_id = aws_eip.EIP.id
  subnet_id     = element(aws_subnet.public_subnets[*].id,1)

  tags = merge(
    var.tags,
    {
      Name = "TerraformNAT"
    },
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_eip" "EIP" {

 tags = merge(
    var.tags,
    {
      Name = "TerraformVPC_EIP"
    },
  )
  
 
}





resource "aws_route_table" "publicrt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = var.route1
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = merge(
    var.tags,
    {
      Name = "Terraformpublicrt"
    },
  )
}


resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id,count.index)
 route_table_id = aws_route_table.publicrt.id
}


resource "aws_route_table" "privatert" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = var.route2
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = merge(
    var.tags,
    {
      Name = "Terraformprivatert"
    },
  )
}




resource "aws_route_table_association" "private_subnet_asso" {
 count = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.privatert.id
}
