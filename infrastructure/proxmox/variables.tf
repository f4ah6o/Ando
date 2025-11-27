variable "proxmox_api_url" {
  description = "Proxmox API endpoint (e.g. https://proxmox.example:8006/api2/json)"
  type        = string
}

variable "proxmox_api_user" {
  description = "API user with permissions to manage LXCs (e.g. root@pam or terraform@pve)"
  type        = string
}

variable "proxmox_api_password" {
  description = "Password or token secret for the Proxmox API user"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification when talking to the Proxmox API"
  type        = bool
  default     = false
}

variable "proxmox_target_node" {
  description = "Proxmox VE node name to place all LXCs on by default"
  type        = string
}

variable "proxmox_pool" {
  description = "Resource pool name for tagging the Nomad/Consul nodes"
  type        = string
  default     = "homelab"
}

variable "vm_bridge" {
  description = "Bridge interface to attach the LXC network to"
  type        = string
  default     = "vmbr0"
}

variable "vm_storage" {
  description = "Default storage backend name for rootfs/cloud-init files"
  type        = string
}

variable "vm_template" {
  description = "LXC template to clone from (e.g. local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst)"
  type        = string
}

variable "vm_disk_size" {
  description = "Disk size for each LXC root filesystem (e.g. 12G)"
  type        = string
  default     = "12G"
}

variable "vm_cores" {
  description = "Number of vCPU cores per LXC"
  type        = number
  default     = 2
}

variable "vm_memory_mb" {
  description = "RAM (in MB) per LXC"
  type        = number
  default     = 2048
}

variable "vm_swap_mb" {
  description = "Swap (in MB) per LXC"
  type        = number
  default     = 512
}

variable "cloud_init_user" {
  description = "Default user created by cloud-init for SSH access"
  type        = string
  default     = "nomad"
}

variable "cloud_init_storage_path" {
  description = "Directory on the storage datastore to place cloud-init files"
  type        = string
  default     = "snippets"
}

variable "ssh_public_keys" {
  description = "SSH public keys allowed for initial access"
  type        = list(string)
  default     = []
}

variable "default_password" {
  description = "Fallback password for LXCs when key auth fails"
  type        = string
  default     = "ChangeMe!"
  sensitive   = true
}

variable "default_tags" {
  description = "Tags applied to all LXCs"
  type        = list(string)
  default     = ["nomad", "consul", "homelab"]
}

variable "nomad_datacenter" {
  description = "Nomad datacenter name used by jobs"
  type        = string
  default     = "lab"
}

variable "consul_datacenter" {
  description = "Consul datacenter name used by jobs"
  type        = string
  default     = "lab"
}

variable "nodes" {
  description = "Map of node hostnames to per-node overrides (ip, cores, memory, tags, cloud_init)"
  type = map(object({
    ip         = optional(string)
    cores      = optional(number)
    memory     = optional(number)
    swap       = optional(number)
    rootfs     = optional(map(any))
    target_node = optional(string)
    ostemplate  = optional(string)
    tags       = optional(list(string))
    password   = optional(string)
    cloud_init = optional(string)
  }))
}
