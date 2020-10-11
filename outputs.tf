# ===================================
# Manage servers in the Hetzner Cloud
# ===================================


# ------------
# Local Values
# ------------

locals {
  output_servers  = [
    for name, server in hcloud_server.servers : merge(server, {
      "networks" = [
        for network in hcloud_server_network.networks : network
          if(tostring(network.server_id) == server.id)
      ],
      "rdns"     = [
        for rdns in hcloud_rdns.server_rdns : rdns
          if(tostring(rdns.server_id) == server.id)
      ]
    })
  ]

  output_rdns     = [
    for name, rdns in hcloud_rdns.server_rdns : merge(rdns, {
      "name"        = name
      "server_name" = try(local.rdns[name].server, null)
    })
  ]

  output_networks = [
    for name, network in hcloud_server_network.networks : merge(network, {
      "name"        = name
      "server_name" = try(local.networks[name].server, null)
    })
  ]
}


# -------------
# Output Values
# -------------

output "servers" {
  description = "A list of all server objects."
  value       = local.output_servers
}

output "server_ids" {
  description = "A map of all server objects indexed by ID."
  value       = {
    for server in local.output_servers : server.id => server
  }
}

output "server_names" {
  description = "A map of all server objects indexed by name."
  value       = {
    for server in local.output_servers : server.name => server
  }
}

output "server_rdns" {
  description = "A list of all server RDNS objects."
  value       = local.output_rdns
}

output "server_rdns_ids" {
  description = "A map of all server RDNS objects indexed by ID."
  value       = {
    for rdns in local.output_rdns : rdns.id => rdns
  }
}

output "server_rdns_names" {
  description = "A map of all server RDNS objects indexed by name."
  value       = {
    for rdns in local.output_rdns : rdns.name => rdns
  }
}

output "server_networks" {
  description = "A list of all server network objects."
  value       = local.output_networks
}

output "server_network_ids" {
  description = "A map of all server network objects indexed by ID."
  value       = {
    for network in local.output_networks : network.id => network
  }
}

output "server_network_names" {
  description = "A map of all server network objects indexed by name."
  value       = {
    for network in local.output_networks : network.name => network
  }
}
