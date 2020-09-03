# Launch configuration
resource "aws_launch_configuration" "netbox-launch-configuration" {
    name                        = "netbox-launch-configuration"
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
resource "aws_autoscaling_group" "netbox-autoscaling-group" {
    name                        = "netbox-autoscaling-group"
    max_size                    = var.max_instance_size
    min_size                    = var.min_instance_size
    desired_capacity            = var.desired_capacity
    vpc_zone_identifier         = [ aws_subnet.netbox_subnet_a.id ]
    launch_configuration        = aws_launch_configuration.netbox-launch-configuration.name
}