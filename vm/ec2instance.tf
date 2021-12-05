provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my-instance" {
  ami           = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"

  tags = {
    Name = "HelloWorld"
  }
}
