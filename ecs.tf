resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}


resource "aws_ecs_task_definition" "ecs_task" {
  family                = "ecs_task"
  container_definitions = file("task-definitions/webserver.json")
  network_mode = "bridge"
}