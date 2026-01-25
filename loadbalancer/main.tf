# Create a load balancer with access logs enabled
resource "aws_lb" "terraform_project_alb" {
  name               = "terraform-project-alb"
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids


  tags = {
    Project = "Terraform VPC"
  }
}


# Create listener for the load balancer
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.terraform_project_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

# Create target group for the load balancer
resource "aws_lb_target_group" "terraform_project_tg" {
  name     = "terraform-project-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}