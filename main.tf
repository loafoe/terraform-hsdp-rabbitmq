resource "random_id" "id" {
  byte_length = 4
}

resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "hsdp_container_host" "rabbitmq" {
  count         = var.nodes
  name          = "rabbitmq-server-${random_id.id.hex}-${count.index}.dev"
  volumes       = 1
  volume_size   = var.volume_size
  instance_type = var.instance_type

  user_groups     = var.user_groups
  user            = var.user
  security_groups = ["analytics"]
}

resource "ssh_resource" "rabbitmq" {
  count = var.nodes

  triggers = {
    cluster_instance_ids = join(",", hsdp_container_host.rabbitmq.*.id)
  }
  host         = hsdp_container_host.rabbitmq[count.index].private_ip
  bastion_host = var.bastion_host
  user         = var.user
  agent        = true

  file {
    content = templatefile("${path.module}/scripts/bootstrap-cluster.sh.tmpl", {
      enable_fluentd = var.hsdp_product_key == "" ? "false" : "true"
      log_driver     = var.hsdp_product_key == "" ? "local" : "fluentd"
      admin_username = "admin"
      admin_password = random_password.password.result
      rabbitmq_image = var.image
      rabbitmq_id    = random_id.id.hex
    })
    destination = "/home/${var.user}/bootstrap-cluster.sh"
    permissions = "0700"
  }

  file {
    content = templatefile("${path.module}/scripts/bootstrap-fluent-bit.sh.tmpl", {
      ingestor_host    = var.hsdp_ingestor_host
      shared_key       = var.hsdp_shared_key
      secret_key       = var.hsdp_secret_key
      product_key      = var.hsdp_product_key
      custom_field     = var.hsdp_custom_field
      fluent_bit_image = var.fluent_bit_image
      debug            = var.hsdp_debug
    })
    destination = "/home/${var.user}/bootstrap-fluent-bit.sh"
    permissions = "0700"
  }


  commands = [
    "docker volume create rabbitmq || /bin/true",
    "/home/${var.user}/bootstrap-fluent-bit.sh",
    "/home/${var.user}/bootstrap-cluster.sh"
  ]
}
