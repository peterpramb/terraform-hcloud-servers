[![License](https://img.shields.io/github/license/peterpramb/terraform-hcloud-servers)](https://github.com/peterpramb/terraform-hcloud-servers/blob/master/LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/peterpramb/terraform-hcloud-servers?sort=semver)](https://github.com/peterpramb/terraform-hcloud-servers/releases/latest)
[![Terraform Version](https://img.shields.io/badge/terraform-%E2%89%A5%200.13.0-623ce4)](https://www.terraform.io)


# terraform-hcloud-servers

[Terraform](https://www.terraform.io) module for managing servers in the [Hetzner Cloud](https://www.hetzner.com/cloud).

It implements the following [provider](#providers) resources:

- [hcloud\_rdns](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/rdns)
- [hcloud\_server](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server)
- [hcloud\_server\_network](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server_network)


## Usage

```terraform
module "server" {
  source  = "github.com/peterpramb/terraform-hcloud-servers?ref=<release>"

  servers = [
    {
      name        = "server-1.example.net"
      image       = "centos-8"
      server_type = "cx11"
      backups     = false
      datacenter  = null
      dns_ptr     = "server-1.example.net"
      firewalls   = []
      iso         = null
      keep_disk   = true
      location    = "nbg1"
      networks    = [
        {
          name      = "network-1"
          subnet_id = "171740-10.0.0.0/24"
          alias_ips = []
          ip        = "10.0.0.10"
        }
      ]
      rescue      = null
      ssh_keys    = [
        "ssh-key-1"
      ]
      user_data   = file("${path.module}/cloud-init.yml")
      labels      = {
        "managed"    = "true"
        "managed_by" = "Terraform"
      }
    }
  ]
}
```

See [examples](https://github.com/peterpramb/terraform-hcloud-servers/blob/master/examples) for more usage details.


## Requirements

| Name | Version |
|------|---------|
| [terraform](https://www.terraform.io) | &ge; 0.13 |


## Providers

| Name | Version |
|------|---------|
| [hcloud](https://registry.terraform.io/providers/hetznercloud/hcloud) | &ge; 1.25 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| servers | List of server objects to be managed. | list(map([*server*](#server))) | See [below](#defaults) | yes |


#### *server*

| Name | Description | Type | Required |
|------|-------------|:----:|:--------:|
| [name](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#name) | Unique name of the server. | string | yes |
| [image](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#image) | Name or ID of the server image. | string | yes |
| [server\_type](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#server_type) | Type of the server to be created. | string | yes |
| [backups](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#backups) | Enable backups for the server. | bool | no |
| [datacenter](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#datacenter) | Name of the datacenter to create the server in. | string | no |
| [dns\_ptr](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/rdns#dns_ptr) | DNS name the host IPs should resolve to. | string | no |
| [firewalls](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#firewall_ids) | List of firewall IDs to assign to the server. | list(number) | no |
| [iso](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#iso) | Name or ID of the ISO image to mount. | string | no |
| [keep\_disk](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#keep_disk) | Keep disk unchanged on server rescale. | bool | no |
| [location](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#location) | Name of the location to create the server in. | string | no |
| networks | List of network objects. | list(map([*network*](#network))) | no |
| [rescue](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#rescue) | Name of the rescue system to boot into. | string | no |
| [ssh\_keys](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#ssh_keys) | List of SSH key names or IDs to be deployed. | list(string) | no |
| [user\_data](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#user_data) | Cloud-Init user data to be used for setup. | string | no |
| [labels](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server#labels) | Map of user-defined labels. | map(string) | no |


#### *network*

| Name | Description | Type | Required |
|------|-------------|:----:|:--------:|
| [name](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network#name) | Name of the network to be assigned to the server. | string | yes |
| [subnet\_id](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server_network#subnet_id) | ID of the subnet to be assigned to the server. | string | yes |
| [alias\_ips](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server_network#alias_ips) | List of additional IPs to be assigned to the server. | list(string) | no |
| [ip](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server_network#ip) | Main IP address to be assigned to the server. | string | no |


### Defaults

```terraform
servers = [
  {
    name        = "server-1"
    image       = "centos-8"
    server_type = "cx11"
    backups     = false
    datacenter  = null
    dns_ptr     = null
    firewalls   = []
    iso         = null
    keep_disk   = false
    location    = null
    networks    = []
    rescue      = null
    ssh_keys    = []
    user_data   = null
    labels      = {}
  }
]
```


## Outputs

| Name | Description |
|------|-------------|
| servers | List of all server objects. |
| server\_ids | Map of all server objects indexed by ID. |
| server\_names | Map of all server objects indexed by name. |
| server\_rdns | List of all server RDNS objects. |
| server\_rdns\_ids | Map of all server RDNS objects indexed by ID. |
| server\_rdns\_names | Map of all server RDNS objects indexed by name. |
| server\_networks | List of all server network objects. |
| server\_network\_ids | Map of all server network objects indexed by ID. |
| server\_network\_names | Map of all server network objects indexed by name. |


### Defaults

```terraform
servers = [
  {
    "backup_window" = ""
    "backups" = false
    "datacenter" = "nbg1-dc3"
    "firewall_ids" = []
    "id" = "8002775"
    "image" = "centos-8"
    "ipv4_address" = "192.0.2.1"
    "ipv6_address" = "2001:DB8::1"
    "ipv6_network" = "2001:DB8::/64"
    "keep_disk" = false
    "labels" = {}
    "location" = "nbg1"
    "name" = "server-1"
    "networks" = []
    "rdns" = []
    "server_type" = "cx11"
    "ssh_keys" = []
    "status" = "running"
  },
]

server_ids = {
  "8002775" = {
    "backup_window" = ""
    "backups" = false
    "datacenter" = "nbg1-dc3"
    "firewall_ids" = []
    "id" = "8002775"
    "image" = "centos-8"
    "ipv4_address" = "192.0.2.1"
    "ipv6_address" = "2001:DB8::1"
    "ipv6_network" = "2001:DB8::/64"
    "keep_disk" = false
    "labels" = {}
    "location" = "nbg1"
    "name" = "server-1"
    "networks" = []
    "rdns" = []
    "server_type" = "cx11"
    "ssh_keys" = []
    "status" = "running"
  }
}

server_names = {
  "server-1" = {
    "backup_window" = ""
    "backups" = false
    "datacenter" = "nbg1-dc3"
    "firewall_ids" = []
    "id" = "8002775"
    "image" = "centos-8"
    "ipv4_address" = "192.0.2.1"
    "ipv6_address" = "2001:DB8::1"
    "ipv6_network" = "2001:DB8::/64"
    "keep_disk" = false
    "labels" = {}
    "location" = "nbg1"
    "name" = "server-1"
    "networks" = []
    "rdns" = []
    "server_type" = "cx11"
    "ssh_keys" = []
    "status" = "running"
  }
}

server_rdns = []

server_rdns_ids = {}

server_rdns_names = {}

server_networks = []

server_network_ids = {}

server_network_names = {}
```


## License

This module is released under the [MIT](https://github.com/peterpramb/terraform-hcloud-servers/blob/master/LICENSE) License.
