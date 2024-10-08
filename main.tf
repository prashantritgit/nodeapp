
provider "aws" {
  region = "us-east-1"  
}

# Create a VPC
resource "aws_vpc" “nodejs” {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "noedejs-vpc”
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.nodejs.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  

  tags = {
    Name = "public-subnet"
  }
}

# Create a internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nodejs.id

  tags = {
    Name = "nodejs-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nodejs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a security group
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.nodejs.id

   Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }



  tags = {
    Name = "ec2-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "webserver” {
  ami           = "ami-0c55b159cbfafe1f0"  
  instance_type = "t2.micro"               
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "webserver"
  }
}
