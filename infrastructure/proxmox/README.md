# Proxmox Dev Environment

Terraform configuration to spin up a small Nomad/Consul lab on a single Proxmox VE node using LXC containers. It mirrors the reference homelab layout while staying lightweight for local testing.

## Prerequisites

- Proxmox VE 7 or newer with an available LXC template (e.g. Debian 12).
- Terraform 1.6+.
- A Proxmox API user with permission to create LXC guests and upload snippets.
- Storage that supports the `snippets` directory for cloud-init files.

## Quick start

1. Copy the example variables file and edit it with your environment details:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   $EDITOR terraform.tfvars
   ```

2. Initialize and review the plan:

   ```bash
   terraform init
   terraform plan
   ```

3. Apply when ready:

   ```bash
   terraform apply
   ```

The module provisions one LXC per entry in the `nodes` map. Each container gets cloud-init user data that installs Nomad/Consul and enables both services. Use the exported `lxc_ips` output to target the nodes with your Nomad jobs once they come online.

## Customizing nodes

You can override per-node settings directly in `terraform.tfvars`:

```hcl
nodes = {
  nomad-01 = {
    ip         = "192.168.10.50/24"
    cores      = 4
    memory     = 4096
    tags       = ["server", "ingress"]
    cloud_init = <<-EOT
      write_files:
        - path: /etc/motd
          content: "Nomad controller"
    EOT
  }
}
```

The base cloud-init template already installs HashiCorp Nomad and Consul, but additional YAML snippets can be injected through the `cloud_init` override.

## Notes

- The Proxmox provider uses the `Telmate/proxmox` plugin; authenticate with either username/password or API token.
- `pm_tls_insecure` can be set to `true` in lab environments with self-signed certificates.
- Networking defaults to DHCP on `vmbr0`; provide static CIDR notation if required.
