resource "aws_ecs_cluster" "netbox_cluster" {
  name = var.cluster_name
}



resource "aws_ecs_task_definition" "netbox_task" {
  family                = "netbox_task"
  container_definitions = file("task-definitions/netbox.json")
  network_mode = "bridge"
}
