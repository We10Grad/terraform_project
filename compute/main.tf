# Create an Ec2 instance with a specific AMI and instance type

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create an EC2 instance that runs a simple web server
resource "aws_instance" "example" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  user_data       = var.user_data
  security_groups = var.security_group_ids
  key_name        = var.key_name

  tags = {
    Name = "TerraformExampleInstance"
  }
}

# Create a launch configuration for the Auto Scaling group
resource "aws_autoscaling_group" "terraform_project_asg" {
  name                      = "terraform_project_asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_configuration      = aws_launch_configuration.terraform_project_lc.id
  vpc_zone_identifier       = [aws_subnet.project_public_1.id, aws_subnet.project_public_2.id, aws_subnet.project_public_3.id]

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}
