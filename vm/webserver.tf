provider "aws" {
    region = "us-east-1"
}

# creating security group for our instances
resource "aws_security_group" "webserver" {
  name        = "helloworld"
  description = "allow ssh and http traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#creating aws instance
resource "aws_instance" "webserver" {
  ami               = "ami-0279c3b3186e54acd"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  security_groups   = [aws_security_group.webserver.name]
  key_name = "hello-world"
  user_data = <<-EOF
                #! /bin/bash
                sudo apt-get install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                echo "<h1>Hello GR World</h1>" >> /var/www/html/index.html
  EOF

  tags = {
        Name = "helloworld"
  }

}

#assigning EIP to our instance
resource "aws_eip" "hello_ip" {
  instance = aws_instance.webserver.id
  tags = {
        Name = "hello_ip"
  }
}

#creating ebs volume
resource "aws_ebs_volume" "data_vol" {
 availability_zone = "us-east-1a"
 size = 1
 tags = {
        Name = "data_volume"
 }

}

#attaching ebs volume to instance
resource "aws_volume_attachment" "hello_world" {
 device_name = "/dev/sda"
 volume_id = aws_ebs_volume.data_vol.id
 instance_id = aws_instance.webserver.id
}

