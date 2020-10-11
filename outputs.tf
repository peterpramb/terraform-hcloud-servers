# ===================================
# Manage servers in the Hetzner Cloud
# ===================================


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
      }, {
        "networks" = [
          for network in hcloud_server_network.servers : network if(tostring(network.server_id) == server.id)
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
