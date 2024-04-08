resource "aws_route_table" "PublicRouteTable" { 
  vpc_id = aws_vpc.demovpc.id
  tags = { 
    Name = "PublicRouteTable" 
  } 
  
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.IGW_TF.id 
  }
  depends_on = [aws_vpc.demovpc, aws_internet_gateway.IGW_TF]
}
resource "aws_route_table" "PrivateRouteTable" { 
  vpc_id = aws_vpc.demovpc.id 
  
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.example.id 
  }

  tags = {
    Name = "PrivateRouteTable" 
  } 
  
  depends_on = [aws_vpc.demovpc] 
}

resource "aws_route_table_association" "PublicRouteTableAssociate" { 
  subnet_id = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.PublicRouteTable.id 
  depends_on = [aws_subnet.public_subnet, aws_route_table.PublicRouteTable] 
}
resource "aws_route_table_association" "PrivateRouteTableAssociate" { 
  subnet_id = aws_subnet.private_subnet.id 
  route_table_id = aws_route_table.PrivateRouteTable.id 
  depends_on = [aws_subnet.private_subnet, aws_route_table.PrivateRouteTable] 
}


resource  "aws_eip" "my_eip"{

    vpc = true
    depends_on   =  [ aws_internet_gateway.IGW_TF ]
    tags = {
    Name = "MyEIP"
    Environment = "Production"
  }
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}