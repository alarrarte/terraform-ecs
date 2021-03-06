resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}


resource "aws_ecs_task_definition" "ecs_task" {
  family                = "ecs_task"
  container_definitions = file("task-definitions/webserver.json")
  network_mode = "bridge"
}


resource "aws_ecs_service" "ecs_service" {
  name            = "ecs_service"
  iam_role        = aws_iam_role.ecs-service-role.name
  launch_type     = "EC2"
  scheduling_strategy = "REPLICA"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  desired_count   = 2

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    	target_group_arn  = aws_alb_target_group.test-target-group.arn
    	container_port    = 80
    	container_name    = "tutum-hw"
	}

}