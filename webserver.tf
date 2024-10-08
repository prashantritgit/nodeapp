resource "aws_instance" "webserver” {
  ami           = "ami-0c55b159cbfafe1f0"  
  instance_type = "t2.micro"               
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "webserver"
  }
}


# Nginx installation script using user_data
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
   EOF

  tags = {
    Name = "webserver"
  }
}
