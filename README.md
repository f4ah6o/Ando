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

```
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
```

---

## Proxmox開発環境 (参考: kencx/homelab)

`infrastructure/proxmox/` にTerraform構成を追加し、Proxmox VE上でNomad/Consul用のLXCノードを簡単に立ち上げられるようにしています。

1. 例示変数をコピーして環境値を設定します。

   ```bash
   cd infrastructure/proxmox
   cp terraform.tfvars.example terraform.tfvars
   $EDITOR terraform.tfvars
   ```

2. 初期化とデプロイ。

   ```bash
   terraform init
   terraform apply
   ```

`nodes` マップに記述した台数分のLXCが作成され、cloud-initでNomad/Consulがインストール・起動されます。詳細は [infrastructure/proxmox/README.md](infrastructure/proxmox/README.md) を参照してください。
