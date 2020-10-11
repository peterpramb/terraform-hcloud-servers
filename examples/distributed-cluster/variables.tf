# ==================================
# Example to manage a server cluster
# ==================================


# ---------------------
# Environment Variables
# ---------------------

# Hetzner Cloud Project API Token
# HCLOUD_TOKEN="<api_token>"


# ---------------
# Input Variables
# ---------------

variable "server_count" {
  description = "The number of servers to manage."
  type        = number
  default     = 3

  validation {
    condition     = var.server_count > 0
    error_message = "The number of servers must be greater than 0."
  }
}

variable "server_domain" {
  description = "The domain name to assign to servers."
  type        = string
  default     = "example.net"
}

variable "server_image" {
  description = "The operating system to deploy on servers."
  type        = string
  default     = "centos-8"
}

variable "server_keys" {
  description = "The list of SSH keys to deploy on servers."
  type        = list(string)
  default     = []
}

variable "server_prefix" {
  description = "The name prefix to assign to servers."
  type        = string
  default     = "server-"
}

variable "server_subnet" {
  description = "The subnet ID to connect servers to."
  type        = string
  default     = null
}

variable "server_type" {
  description = "The type of servers to manage."
  type        = string
  default     = "cx11"
}

variable "labels" {
  description = "The map of labels to be assigned to all managed resources."
  type        = map(string)
  default     = {
    "managed"    = "true"
    "managed_by" = "Terraform"
  }
}
