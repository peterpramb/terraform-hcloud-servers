# ====================================
# Manages servers in the Hetzner Cloud
# ====================================


# ------------
# Local Values
# ------------

locals {
  # Build a map of all provided server objects, indexed by server name.
  servers = {
    for server in var.servers : server.name => server
  }

  # Build a map of all provided server floating IP ids, indexed by server
  # name and floating IP id
  float_ips = {
    for float_ip in flatten([
      for server in local.servers : [
        for float_ip in server.float_ips : { "floating_ip_id" = float_ip
                                             "server" = server.name }
      ] if(lookup(server, "float_ips", null) != null)
    ]) : "${float_ip.server}:${float_ip.floating_ip_id}" => float_ip
  }

  # Build a map of all provided server network objects, indexed by server
  # name and subnet id
  networks = {
    for network in flatten([
      for server in local.servers : [
        for network in server.networks : merge(network, { "server" = server.name })
      ] if(lookup(server, "networks", null) != null)
    ]) : "${network.server}:${network.subnet_id}" => network
  }

  # Build a map of all provided server volume objects, indexed by server
  # name and volume id
  volumes = {
    for volume in flatten([
      for server in local.servers : [
        for volume in server.volumes : merge(volume, { "server" = server.name })
      ] if(lookup(server, "volumes", null) != null)
    ]) : "${volume.server}:${volume.volume_id}" => volume
  }
}


# -------
# Servers
# -------

resource "hcloud_server" "servers" {
  for_each    = local.servers

  name        = each.value.name
  image       = each.value.image
  server_type = each.value.server_type
  backups     = each.value.backups
  datacenter  = each.value.datacenter
  keep_disk   = each.value.keep_disk
  location    = each.value.location
  ssh_keys    = each.value.ssh_keys
  user_data   = each.value.user_data

  labels      = each.value.labels
}


# -----------
# Server RDNS
# -----------

resource "hcloud_rdns" "servers" {
  for_each   = merge(
    {
      for server in hcloud_server.servers : "${server.name}:ipv4" => {
        "dns_ptr"    = server.name
        "ip_address" = server.ipv4_address
        "server_id"  = server.id
      } if(local.servers[server.name].set_rdns == true)
    },
    {
      for server in hcloud_server.servers : "${server.name}:ipv6" => {
        "dns_ptr"    = server.name
        "ip_address" = server.ipv6_address
        "server_id"  = server.id
      } if(local.servers[server.name].set_rdns == true)
    }
  )

  dns_ptr    = each.value.dns_ptr
  ip_address = each.value.ip_address
  server_id  = each.value.server_id
}


# -------------------
# Server Floating IPs
# -------------------

resource "hcloud_floating_ip_assignment" "servers" {
  for_each       = local.float_ips

  floating_ip_id = each.value.floating_ip_id
  server_id      = hcloud_server.servers[each.value.server].id
}


# ---------------
# Server Networks
# ---------------

resource "hcloud_server_network" "servers" {
  for_each  = local.networks

  server_id = hcloud_server.servers[each.value.server].id
  subnet_id = each.value.subnet_id
  alias_ips = each.value.alias_ips
  ip        = each.value.ip
}


# --------------
# Server Volumes
# --------------

resource "hcloud_volume_attachment" "servers" {
  for_each  = local.volumes

  server_id = hcloud_server.servers[each.value.server].id
  volume_id = each.value.volume_id
  automount = each.value.automount
}
