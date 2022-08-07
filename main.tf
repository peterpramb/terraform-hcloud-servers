# ===================================
# Manage servers in the Hetzner Cloud
# ===================================


# ------------
# Local Values
# ------------

locals {
  # Build a map of all provided server objects, indexed by server name:
  servers  = {
    for server in var.servers : server.name => server
  }

  # Build a map of all provided server RDNS objects, indexed by server
  # name and protocol:
  rdns     = merge(
    {
      for server in local.servers : "${server.name}:ipv4" => merge(server, {
        "ip_address" = hcloud_server.servers[server.name].ipv4_address
        "server"     = server.name
      }) if(try(server.dns_ptr, null) != null && server.dns_ptr != "")
    },
    {
      for server in local.servers : "${server.name}:ipv6" => merge(server, {
        "ip_address" = hcloud_server.servers[server.name].ipv6_address
        "server"     = server.name
      }) if(try(server.dns_ptr, null) != null && server.dns_ptr != "")
    }
  )

  # Build a map of all provided server network objects, indexed by server
  # and network names:
  networks = {
    for network in flatten([
      for server in local.servers : [
        for network in server.networks : merge(network, {
          "server" = server.name
        })
      ] if(server.networks != null)
    ]) : "${network.server}:${network.name}" => network
  }
}


# -------
# Servers
# -------

resource "hcloud_server" "servers" {
  for_each           = local.servers

  name               = each.value.name
  image              = each.value.image
  server_type        = each.value.server_type
  backups            = each.value.backups
  datacenter         = each.value.datacenter
  delete_protection  = each.value.protection
  firewall_ids       = each.value.firewalls
  iso                = each.value.iso
  keep_disk          = each.value.keep_disk
  location           = each.value.location
  rebuild_protection = each.value.protection
  rescue             = each.value.rescue
  ssh_keys           = each.value.ssh_keys
  user_data          = each.value.user_data

  labels             = each.value.labels
}


# -----------
# Server RDNS
# -----------

resource "hcloud_rdns" "server_rdns" {
  for_each   = local.rdns

  dns_ptr    = each.value.dns_ptr
  ip_address = each.value.ip_address
  server_id  = hcloud_server.servers[each.value.server].id
}


# ---------------
# Server Networks
# ---------------

resource "hcloud_server_network" "networks" {
  for_each   = local.networks

  server_id  = hcloud_server.servers[each.value.server].id
  subnet_id  = each.value.subnet_id
  alias_ips  = each.value.alias_ips
  ip         = each.value.ip
}
