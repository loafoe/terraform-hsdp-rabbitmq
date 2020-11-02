<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="500px">

# HSDP RabbitMQ module

Module to create a RabbitMQ server deployed on the HSDP Container
Host infrastructure. Use this module if you need a version of RabbitMQ
which is not supported by the [HSDP RabbitMQ Service Broker](https://www.hsdp.io/documentation/rabbitmq/rabbitmq-service-broker)

> This module currently create single-node clusters only!

```hcl
module "rabbitmq" {
  source = "github.com/philips-labs/terraform-hsdp-rabbitmq"

  nodes        = 1
  bastion_host = "bastion.host"
  user         = "ronswanson"
  user_groups  = ["ronswanson", "poc"]
  private_key  = file("~/.ssh/dec.key")
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

## Requirements

| Name | Version |
|------|---------|
| hsdp | >= 0.6.7 |

## Providers

| Name | Version |
|------|---------|
| hsdp | >= 0.6.7 |
| null | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion\_host | Bastion host to use for SSH connections | `string` | n/a | yes |
| fluent\_bit\_image | Fluent-bit image | `string` | `"philipssoftware/fluent-bit-out-hsdp:latest"` | no |
| hsdp\_custom\_field | Post structured JSON message to HSDP Logging custom field | `string` | `"true"` | no |
| hsdp\_debug | Enable debugging of HSDP services | `string` | `"false"` | no |
| hsdp\_ingestor\_host | HSDP Logging ingestor host | `string` | `"https://logingestor2-client-test.us-east.philips-healthsuite.com"` | no |
| hsdp\_product\_key | HSDP Logging product key | `string` | `""` | no |
| hsdp\_region | The HSDP region of the deployment | `string` | `"us-east"` | no |
| hsdp\_secret\_key | HSDP Logging secret key | `string` | `""` | no |
| hsdp\_shared\_key | HSDP Logging shared key | `string` | `""` | no |
| image | The docker image to use | `string` | `"bitnami/rabbitmq:latest"` | no |
| instance\_type | The instance type to use | `string` | `"t2.medium"` | no |
| nodes | Number of nodes | `number` | `1` | no |
| private\_key | Private key for SSH access | `string` | n/a | yes |
| user | LDAP user to use for connections | `string` | n/a | yes |
| user\_groups | User groups to assign to cluster | `list(string)` | n/a | yes |
| volume\_size | The volume size to use in GB | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password | RabbitMQ admin password |
| admin\_port | RabbitMQ Admin HTTP port |
| admin\_username | RabbitMQ admin username |
| dial | AMQP Dial string |
| hostname | RabbitMQ hostname |
| name\_nodes | Container Host RabbitMQ instance names |
| nodes | Container Host RabbitMQ instances |
| port | RabbitMQ AMQP port |
