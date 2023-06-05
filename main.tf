resource aws_instance "first_terra" {
   ami = "ami-053b0d53c279acc90"
   instance_type = "t2.micro"
subnet_id = aws_subnet.public-subnet.id
key_name = "TestKey"
vpc_security_group_ids = [aws_security_group.main-sg.id]

tags = {
 Name = "first_terra"
}
}

resource "aws_eip" "ec2-eip" {
instance = aws_instance.first_terra.id
vpc = true

}



resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Main-VPC"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Public-Subnet"
  }
}



resource "aws_security_group" "main-sg" {
  name        = "main-sg"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]	
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "main-sg"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-IGW"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }


  tags = {
    Name = "Public-Rt"
  }
}

resource "aws_route_table_association" "public-rt-ass" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_eip" "eip" {
   vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
   allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public-subnet.id

tags = {
Name = "Nat-gw"
}
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
 tags = {
    Name = "example"
  }
}

