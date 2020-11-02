resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 32
  special = true
  override_special = "_%@"
}

resource "hsdp_container_host" "rabbitmq" {
  count         = var.nodes
  name          = "rabbitmq-server-${random_id.id.hex}-${count.index}.dev"
  volumes       = 1
  volume_size   = var.volume_size
  instance_type = var.instance_type

  user_groups     = var.user_groups
  security_groups = ["analytics"]

  connection {
    bastion_host = var.bastion_host
    host         = self.private_ip
    user         = var.user
    private_key  = var.private_key
    script_path  = "/home/${var.user}/bootstrap.bash"
  }

  provisioner "remote-exec" {
    inline = [
      "docker volume create rabbitmq",
    ]
  }
}

resource "null_resource" "cluster" {
  count = var.nodes

  triggers = {
    cluster_instance_ids = join(",", hsdp_container_host.rabbitmq.*.id)
  }

  connection {
    bastion_host = var.bastion_host
    host         = element(hsdp_container_host.rabbitmq.*.private_ip, count.index)
    user         = var.user
    private_key  = var.private_key
    script_path  = "/home/${var.user}/cluster.bash"
  }

  provisioner "file" {
    content = templatefile("${path.module}/scripts/bootstrap-cluster.sh.tmpl", {
      enable_fluentd             = var.hsdp_product_key == "" ? "false" : "true"
      log_driver                 = var.hsdp_product_key == "" ? "local" : "fluentd"
      admin_username             = "admin"
      admin_password             = random_password.password.result
      rabbitmq_image             = var.image
      rabbitmq_id                = random_id.id.hex
    })
    destination = "/home/${var.user}/bootstrap-cluster.sh"
  }

  provisioner "file" {
    content = templatefile("${path.module}/scripts/bootstrap-fluent-bit.sh.tmpl", {
      ingestor_host    = var.hsdp_ingestor_host
      shared_key       = var.hsdp_shared_key
      secret_key       = var.hsdp_secret_key
      product_key      = var.hsdp_product_key
      custom_field     = var.hsdp_custom_field
      fluent_bit_image = var.fluent_bit_image
    })
    destination = "/home/${var.user}/bootstrap-fluent-bit.sh"
  }


  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /home/${var.user}/bootstrap-fluent-bit.sh",
      "/home/${var.user}/bootstrap-fluent-bit.sh",
      "chmod +x /home/${var.user}/bootstrap-cluster.sh",
      "/home/${var.user}/bootstrap-cluster.sh"
    ]
  }
}
