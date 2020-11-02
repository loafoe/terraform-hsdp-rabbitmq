output "nodes" {
  description = "Container Host RabbitMQ instances"
  value       = hsdp_container_host.rabbitmq.*.private_ip
}

output "name_nodes" {
  description = "Container Host RabbitMQ instance names"
  value       = hsdp_container_host.rabbitmq.*.name
}

output "amqp_port" {
  description = "RabbitMQ AMQP port"
  value       = "10000"
}

output "admin_port" {
  description = "RabbitMQ Admin HTTP port"
  value       = "10001"
}
