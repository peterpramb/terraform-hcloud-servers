# ===================================
# Manage servers in the Hetzner Cloud
# ===================================


# ---------------
# Input Variables
# ---------------

variable "servers" {
  description = "The list of server objects to be managed. Each server object supports the following parameters: 'name' (string, required), 'image' (string, required), 'server_type' (string, required), 'backups' (bool, optional), 'datacenter' (string, optional), 'dns_ptr' (string, optional), 'firewalls' (list of firewall IDs, optional), 'iso' (string, optional), 'keep_disk' (bool, optional), 'location' (string, optional), 'networks' (list of network objects, optional), 'placement' (string, optional), 'protection' (bool, optional), 'public_net' (ipv4/ipv6 string tuple, optional), 'rescue' (string, optional), 'ssh_keys' (list of SSH key IDs/names, optional), 'user_data' (string, optional), 'labels' (map of KV pairs, optional). Each network object supports the following parameters: 'name' (string, required), 'subnet_id' (string, required), 'alias_ips' (list of IP addresses, optional), 'ip' (string, optional)."

  type        = list(
    object({
      name        = string
      image       = string
      server_type = string
      backups     = bool
      datacenter  = string
      dns_ptr     = string
      firewalls   = list(number)
      iso         = string
      keep_disk   = bool
      location    = string
      networks    = list(
        object({
          name      = string
          subnet_id = string
          alias_ips = list(string)
          ip        = string
        })
      )
      placement   = string
      protection  = bool
      public_net  = tuple([string, string])
      rescue      = string
      ssh_keys    = list(string)
      user_data   = string
      labels      = map(string)
    })
  )

  default     = [
    {
      name        = "server-1"
      image       = "rocky-9"
      server_type = "cx11"
      backups     = false
      datacenter  = null
      dns_ptr     = null
      firewalls   = []
      iso         = null
      keep_disk   = false
      location    = null
      networks    = []
      placement   = null
      protection  = false
      public_net  = null
      rescue      = null
      ssh_keys    = []
      user_data   = null
      labels      = {}
    }
  ]

  validation {
    condition     = can([
      for server in var.servers : regex("\\w+", server.name)
    ])
    error_message = "All servers must have a valid 'name' attribute specified."
  }

  validation {
    condition     = can([
      for server in var.servers : regex("\\w+", server.image)
    ])
    error_message = "All servers must have a valid 'image' attribute specified."
  }

  validation {
    condition     = can([
      for server in var.servers : regex("\\w+", server.server_type)
    ])
    error_message = "All servers must have a valid 'server_type' attribute specified."
  }

  validation {
    condition     = can([
      for server in var.servers : [
        for network in server.networks : regex("\\w+", network.name)
      ]
    ])
    error_message = "All networks must have a valid 'name' attribute specified."
  }

  validation {
    condition     = can([
      for server in var.servers : [
        for network in server.networks : regex("\\w+", network.subnet_id)
      ]
    ])
    error_message = "All networks must have a valid 'subnet_id' attribute specified."
  }
}
