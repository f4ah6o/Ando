# Ando

![Terraform](https://img.shields.io/badge/IaC-Terraform-purple.svg)
![Nomad](https://img.shields.io/badge/Orchestrator-Nomad-green.svg)
![Consul](https://img.shields.io/badge/ServiceMesh-Consul-pink.svg)
![NetBird](https://img.shields.io/badge/Network-NetBird-orange.svg)

* 安堵
* 低コスト
* 低ベンダーロックイン

## 技術スタック

* NetBird
* Nomad
* Consul
* Envoy
* Certbot(DNS-01 Challenge) 
* **SquidSCAS-based CASB**: **Squid + c-icap + SquidSCAS**
* **E2E Load Testing**: **k6**

---

## 📂 Directory Structure

.
├── infrastructure/          # Infrastructure as Code (Terraform/OpenTofu)
│   ├── modules/             # Reusable modules
│   ├── akamai/              # Production setup (VMs + Firewalls)
│   └── proxmox/             # Development setup (Proxmox VE LXC)
├── orchestration/           # Nomad Job Specifications (HCL)
│   ├── jobs/
│   │   ├── system/
│   │   │   ├── ingress.nomad.hcl # Envoy Ingress Gateway
│   │   │   ├── certbot.nomad.hcl # Let's Encrypt Automation
│   │   │   └── casb.nomad.hcl    # Squid + c-icap + SquidSCAS
│   │   └── workloads/            # Template for your apps
│   └── config/              # Shared configurations
└── docs/                    # Setup guides & Security details

---
