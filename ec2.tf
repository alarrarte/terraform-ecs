resource "aws_lb" "test_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.subnet.*.id
  security_groups = [aws_security_group.alb.id]
  enable_deletion_protection = false
}