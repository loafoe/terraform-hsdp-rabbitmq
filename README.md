<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="500px">

# HSDP RabbitMQ module

Module to create a RabbitMQ server deployed on the HSDP Container
Host infrastructure.

```hcl
module "rabbitmq" {
  source = "github.com/philips-labs/terraform-hsdp-rabbitmq"

  nodes        = 1
  bastion_host = "bastion.host"
  user         = "ronswanson"
  private_key  = file("~/.ssh/dec.key")
  user_groups  = ["ronswanson", "poc"]
}
```

__IMPORTANT SECURITY INFORMATION__
> Operating and maintaining applications on Container Host is always
> your responsibility. This includes ensuring any security 
> measures are in place in case you need them.


# Contact / Getting help

Andy Lo-A-Foe <andy.lo-a-foe@philips.com>

# License

License is MIT
