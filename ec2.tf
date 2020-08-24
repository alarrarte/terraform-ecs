# ALB
resource "aws_lb" "test_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.subnet.*.id
  security_groups = [aws_security_group.alb.id]
  enable_deletion_protection = false
}


resource "aws_alb_target_group" "test-target-group" {
    name                = "test-target-group"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = aws_vpc.ecs_vpc.id

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    depends_on = [
        aws_lb.test_alb
    ]
}

resource "aws_alb_listener" "test_alb_listener" {
    load_balancer_arn = aws_lb.test_alb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.test-target-group.arn
        type             = "forward"
    }
}


# Launch configuration
resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = var.lc_ami
    instance_type               = var.lc_flavor
    iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id

    root_block_device {
      volume_type = "standard"
      volume_size = 30
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = [ aws_security_group.ec2-allow.id ]
    associate_public_ip_address = "true"
    key_name                    = var.ecs_key_pair_name
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
                                  EOF
}



# ASG
resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = var.max_instance_size
    min_size                    = var.min_instance_size
    desired_capacity            = var.desired_capacity
    vpc_zone_identifier         = aws_subnet.subnet.*.id
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
}