terraform {
  required_providers {
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.20.5"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.1.0"
    }

  }
}
