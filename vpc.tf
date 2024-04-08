resource "aws_vpc" "demovpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default" 
  enable_dns_support = "true" 
  enable_dns_hostnames = "true"
  tags = { 
    Name = "demovpc" 
  } 
 }

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh" 
  vpc_id = aws_vpc.demovpc.id 
  description = "Allow SSH inbound traffic / Allow all outbound traffic" 
  ingress { 
     from_port = 22 
     to_port = 22 
     protocol = "tcp" 
     cidr_blocks = ["0.0.0.0/0"] 
  }
  
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = { 
    Name = "demovpc_allow_ssh" 
  }
  depends_on = [aws_vpc.demovpc] 
}

resource "aws_security_group" "allow_local" {
  name = "allow_local" 
  description = "Allow all traffic from local vpc" 
  ingress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["10.0.0.0/16"] 
  }
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  vpc_id = aws_vpc.demovpc.id 
  tags = { 
    Name = "demovpc_allow_all_from_local" 
  }
  depends_on = [aws_vpc.demovpc] 
}

resource "aws_internet_gateway" "IGW_TF" { 
  vpc_id = aws_vpc.demovpc.id 
  tags = { 
    Name = "IGW_TF" 
  }
  depends_on = [aws_vpc.demovpc] 
}

resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.private_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_local.id]
  
}