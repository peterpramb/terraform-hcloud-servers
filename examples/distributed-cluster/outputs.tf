# ==================================
# Example to manage a server cluster
# ==================================


# -------------
# Output Values
# -------------

output "server_ips" {
  description = "A list of server name and IP address tuples."
  value       = [
    for name, server in module.server.server_names : [name, server.ipv4_address]
  ]
}
