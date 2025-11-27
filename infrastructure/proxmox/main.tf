terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_api_user
  pm_password     = var.proxmox_api_password
  pm_tls_insecure = var.proxmox_tls_insecure
}

locals {
  # Base template configuration shared by every Nomad/Consul node
  common_lxc_config = {
    target_node = var.proxmox_target_node
    cores       = var.vm_cores
    memory      = var.vm_memory_mb
    swap        = var.vm_swap_mb
    ostemplate  = var.vm_template
    unprivileged = true
    onboot       = true
    features = {
      nesting = true
      fuse    = true
    }
    rootfs = {
      storage = var.vm_storage
      size    = var.vm_disk_size
    }
    network = [{
      name   = "eth0"
      bridge = var.vm_bridge
      ip     = "dhcp"
    }]
  }
}

resource "proxmox_lxc" "server" {
  for_each = var.nodes

  # Merge per-node overrides with common defaults
  hostname     = each.key
  ostemplate   = lookup(each.value, "ostemplate", local.common_lxc_config.ostemplate)
  unprivileged = local.common_lxc_config.unprivileged
  target_node  = lookup(each.value, "target_node", local.common_lxc_config.target_node)
  password     = lookup(each.value, "password", var.default_password)
  cores        = lookup(each.value, "cores", local.common_lxc_config.cores)
  memory       = lookup(each.value, "memory", local.common_lxc_config.memory)
  swap         = lookup(each.value, "swap", local.common_lxc_config.swap)
  rootfs       = lookup(each.value, "rootfs", local.common_lxc_config.rootfs)
  features     = lookup(each.value, "features", local.common_lxc_config.features)
  onboot       = local.common_lxc_config.onboot

  network { # main interface
    name   = "eth0"
    bridge = var.vm_bridge
    ip     = lookup(each.value, "ip", "dhcp")
  }

  # Cloud-init style provisioning to bootstrap Nomad/Consul
  ssh_public_keys = var.ssh_public_keys
  start           = true

  # Templates commonly use serial console
  ostype  = lookup(each.value, "ostype", "ubuntu")
  pool    = var.proxmox_pool
  tags    = join(",", concat(var.default_tags, lookup(each.value, "tags", [])))

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

resource "proxmox_file" "cloud_init" {
  for_each = var.nodes

  content      = templatefile("${path.module}/templates/cloud-init.tftpl", {
    hostname           = each.key
    default_user       = var.cloud_init_user
    ssh_public_keys    = var.ssh_public_keys
    nomad_datacenter   = var.nomad_datacenter
    consul_datacenter  = var.consul_datacenter
    extra_cloud_config = lookup(each.value, "cloud_init", "")
  })
  datastore_id = var.vm_storage
  node_name    = local.common_lxc_config.target_node
  directory    = var.cloud_init_storage_path
  file_name    = "${each.key}-cloud-init.yaml"
}

output "lxc_ips" {
  description = "Allocated IP addresses for Nomad/Consul nodes"
  value = {
    for name, cfg in proxmox_lxc.server : name => cfg.network[0].ip
  }
}
