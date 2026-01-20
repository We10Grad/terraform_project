
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_name" {
  type    = string
  default = "my-key-pair"
}
variable "ami_id" {
  type    = string
  default = "ami-0c55b159cbfafe1f0" # Example AMI ID for Amazon Linux 2 in us-east-1
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "user_data" {
  type    = string
  default = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              echo "Hello, World!" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
}

# Create a security group that allows HTTP and SSH inbound traffic and all outbound traffic
resource "aws_security_group" "terraform_project_sg" {
  name        = "terraform_project_sg"
  description = "Allow HTTP and SSH inbound traffic and all outbound traffic"

  tags = {
    Name = "terraform_project_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.terraform_project_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.terraform_project_sg.id
  cidr_ipv4         = "73.228.206.20/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraform_project_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create an SSH key pair to access the EC2 instance
resource "aws_key_pair" "terraform_project_key" {
  key_name   = "terraform_project_key"
  public_key = file("~/.ssh/aws_terraform_key.pub")
}