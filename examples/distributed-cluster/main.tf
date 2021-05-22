# ==================================
# Example to manage a server cluster
# ==================================


# ------------
# Local Values
# ------------

locals {
  # Enrich user configuration for server module:
  servers = [
    for index in range(1, var.server_count + 1) : {
      "name"        = "${var.server_prefix}${index}"
      "image"       = var.server_image
      "server_type" = var.server_type
      "backups"     = false
      "datacenter"  = null
      "dns_ptr"     = "${var.server_prefix}${index}.${var.server_domain}"
      "iso"         = null
      "keep_disk"   = true
      "location"    = element(data.hcloud_locations.all.names, index - 1)
      "networks"    = [
        for subnet in [var.server_subnet] : {
          "name"      = "network-1"
          "subnet_id" = var.server_subnet
          "alias_ips" = []
          "ip"        = null
        } if(var.server_subnet != null && var.server_subnet != "")
      ]
      "rescue"      = null
      "ssh_keys"    = var.server_keys
      "user_data"   = null
      "labels"      = var.labels
    }
  ]
}


# ---------
# Locations
# ---------

data "hcloud_locations" "all" {
}


# -------
# Servers
# -------

module "server" {
  source  = "github.com/peterpramb/terraform-hcloud-servers"

  servers = local.servers
}
