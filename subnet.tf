resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.0.0/24" 
  map_public_ip_on_launch = "true" 
  vpc_id = aws_vpc.demovpc.id
  tags = { 
    Name = "demo_public_subnet" 
  }
  depends_on = [aws_vpc.demovpc] 
}
resource "aws_subnet" "private_subnet" { 
  cidr_block = "10.0.1.0/24" 
  vpc_id = aws_vpc.demovpc.id 
  tags = { 
    Name = "demo_private_subnet" 
  }
  depends_on = [aws_vpc.demovpc] 
 }



