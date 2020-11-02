output "nodes" {
  description = "Container Host RabbitMQ instances"
  value       = hsdp_container_host.rabbitmq.*.private_ip
}

output "name_nodes" {
  description = "Container Host RabbitMQ instance names"
  value       = hsdp_container_host.rabbitmq.*.name
}

output "port" {
  description = "RabbitMQ AMQP port"
  value       = "10000"
}

output "hostname" {
  description = "RabbitMQ hostname"
  value       = element(hsdp_container_host.rabbitmq.*.private_ip, 0)
}

output "admin_port" {
  description = "RabbitMQ Admin HTTP port"
  value       = "10001"
}

output "admin_username" {
  description = "RabbitMQ admin username"
  value       = "admin"
}

output "admin_password" {
  description = "RabbitMQ admin password"
  value       = random_password.password.result
}

output "dial" {
  description = "AMQP Dial string"
  value       = "amqp://${element(hsdp_container_host.rabbitmq.*.private_ip, 0)}:10000"
}
