# ====================================
# Manages servers in the Hetzner Cloud
# ====================================


# -------------
# Output Values
# -------------

output "server_ids" {
  description = "A map of all server ids and associated names."
  value = {
    for name, server in hcloud_server.servers : server.id => name
  }
}

output "server_names" {
  description = "A map of all server names and associated ids."
  value = {
    for name, server in hcloud_server.servers : name => server.id
  }
}

output "servers" {
  description = "A list of all server and associated objects."
  value = [
    for server in hcloud_server.servers : merge(server, {
        "rdns" = [
          for rdns in hcloud_rdns.servers : rdns if(tostring(rdns.server_id) == server.id)
        ]
      }, {
        "floating_ips" = [
          for float_ip in hcloud_floating_ip_assignment.servers : float_ip if(tostring(float_ip.server_id) == server.id)
        ]
      }, {
        "networks" = [
          for network in hcloud_server_network.servers : network if(tostring(network.server_id) == server.id)
        ]
      }, {
        "volumes" = [
          for volume in hcloud_volume_attachment.servers : volume if(tostring(volume.server_id) == server.id)
        ]
    })
  ]
}

output "server_rdns_ids" {
  description = "A map of all server rdns ids and associated names."
  value = {
    for name, rdns in hcloud_rdns.servers : rdns.id => name
  }
}

output "server_rdns_names" {
  description = "A map of all server rdns names and associated ids."
  value = {
    for name, rdns in hcloud_rdns.servers : name => rdns.id
  }
}

output "server_rdns" {
  description = "A list of all server rdns objects."
  value = [
    for rdns in hcloud_rdns.servers : rdns
  ]
}

output "server_floating_ip_ids" {
  description = "A map of all server floating IP ids and associated names."
  value = {
    for name, float_ip in hcloud_floating_ip_assignment.servers : float_ip.id => name
  }
}

output "server_floating_ip_names" {
  description = "A map of all server floating IP names and associated ids."
  value = {
    for name, float_ip in hcloud_floating_ip_assignment.servers : name => float_ip.id
  }
}

output "server_floating_ips" {
  description = "A list of all server floating IP objects."
  value = [
    for float_ip in hcloud_floating_ip_assignment.servers : float_ip
  ]
}

output "server_network_ids" {
  description = "A map of all server network ids and associated names."
  value = {
    for name, network in hcloud_server_network.servers : network.id => name
  }
}

output "server_network_names" {
  description = "A map of all server network names and associated ids."
  value = {
    for name, network in hcloud_server_network.servers : name => network.id
  }
}

output "server_networks" {
  description = "A list of all server network objects."
  value = [
    for network in hcloud_server_network.servers : network
  ]
}

output "server_volume_ids" {
  description = "A map of all server volume ids and associated names."
  value = {
    for name, volume in hcloud_volume_attachment.servers : volume.id => name
  }
}

output "server_volume_names" {
  description = "A map of all server volume names and associated ids."
  value = {
    for name, volume in hcloud_volume_attachment.servers : name => volume.id
  }
}

output "server_volumes" {
  description = "A list of all server volume objects."
  value = [
    for volume in hcloud_volume_attachment.servers : volume
  ]
}
