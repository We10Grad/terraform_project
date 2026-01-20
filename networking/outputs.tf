output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.project_public_1.id,
    aws_subnet.project_public_2.id,
    aws_subnet.project_public_3.id,
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.project_private_1.id,
    aws_subnet.project_private_2.id,
  ]
}
