# ===================================
# Manage servers in the Hetzner Cloud
# ===================================


# ---------------
# Input Variables
# ---------------

variable "servers" {
  description = "The list of server objects to be managed. Each server object supports the following parameters: 'name' (string, required), 'image' (string, required), 'server_type' (string, required), 'backups' (bool, optional), 'datacenter' (string, optional), 'dns_ptr' (string, optional), 'iso' (string, optional), 'keep_disk' (bool, optional), 'location' (string, optional), 'networks' (list of network objects, optional), 'rescue' (string, optional), 'ssh_keys' (list of SSH key ids/names, optional), 'user_data' (string, optional), 'labels' (map of KV pairs, optional). Each network object supports the following parameters: 'subnet_id' (string, required), 'alias_ips' (list of IP addresses, optional), 'ip' (string, optional)."

  type        = list(
    object({
      name         = string
      image        = string
      server_type  = string
      backups      = bool
      datacenter   = string
      dns_ptr      = string
      iso          = string
      keep_disk    = bool
      location     = string
      networks     = list(
        object({
          subnet_id = string
          alias_ips = list(string)
          ip        = string
        })
      )
      rescue       = string
      ssh_keys     = list(string)
      user_data    = string
      labels       = map(string)
    })
  )

  default     = [
    {
      name        = "server-1"
      image       = "centos-8"
      server_type = "cx11"
      backups     = false
      datacenter  = null
      dns_ptr     = null
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
        for network in server.networks : regex("\\w+", network.subnet_id)
      ]
    ])
    error_message = "All networks must have a valid 'subnet_id' attribute specified."
  }
}
