resource "aws_instance" "PublicEC2" { 
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.nano" 
  tags = { 
    Name = "PublicEC2" 
  }
  key_name = "keypair"
  subnet_id = aws_subnet.public_subnet.id 
  vpc_security_group_ids = [aws_security_group.allow_ssh.id] 
  depends_on = [aws_vpc.demovpc, aws_subnet.public_subnet] 
}

resource "aws_instance" "PrivateEC2" { 
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.nano" 
  tags = { 
    Name = "PrivateEC2" 
  }
  key_name = "keypair"
  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }
  depends_on = [aws_vpc.demovpc, aws_subnet.private_subnet , aws_network_interface.test] 
  user_data = "${file("mysql_script.sh")}"
}

