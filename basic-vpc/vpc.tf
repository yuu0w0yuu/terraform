### VPC
resource "aws_vpc" "main" {

  cidr_block = local.vpc.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.service}-${local.env}-vpc"
  }
}

### Subnets
resource "aws_subnet" "public" {
  vpc_id   = aws_vpc.main.id
  for_each = { for i in local.vpc.public_subnets : i.az => i }

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.service}-${local.env}-public-${substr(each.value.az, -2, 2)}"
  }
}

resource "aws_subnet" "private" {
  vpc_id   = aws_vpc.main.id
  for_each = { for i in local.vpc.private_subnets : i.az => i }

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.service}-${local.env}-private-${substr(each.value.az, -2, 2)}"
  }
}

### Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.service}-${local.env}-internet-gateway"
  }
}

resource "aws_eip" "natgateway" {
  domain = "vpc"
  tags = {
    Name = "${local.service}-${local.env}-eip-natgateway"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgateway.id
  #コストを考慮して1aにのみ作成
  subnet_id = aws_subnet.public["ap-northeast-1a"].id
  tags = {
    Name = "${local.service}-${local.env}-natgateway"
  }
}

### Route Table
## Public Subnet -> Internet
resource "aws_route_table" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${local.service}-${local.env}-rtb-internet-gateway"
  }
}

resource "aws_route_table_association" "internet_gateway" {
  for_each       = { for i in local.vpc.public_subnets : i.az => i }
  route_table_id = aws_route_table.internet_gateway.id
  subnet_id      = aws_subnet.public[each.value.az].id
}

## Private Subnet -> Nat Gateway -> Internet
resource "aws_route_table" "natgateway" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = "${local.service}-${local.env}-rtb-natgateway"
  }
}

resource "aws_route_table_association" "natgateway" {
  for_each       = { for i in local.vpc.private_subnets : i.az => i }
  route_table_id = aws_route_table.natgateway.id
  subnet_id      = aws_subnet.private[each.value.az].id
}