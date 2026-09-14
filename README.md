# Hub-and-Spoke-Architecture

This project is an Azure network architecture designed to demonstrate my understanding of enterprise networking and cloud security principles. It uses a Hub-and-Spoke topology, with a central hub responsible for controlling and securing traffic to and from the spoke networks. The environment is managed as Infrastructure as Code and deployed through an automated CI/CD workflow.

The infrastructure is provisioned entirely with Terraform and deployed to Azure using GitHub Actions. Outbound traffic is routed through Azure Firewall for centralised inspection, while Azure Bastion provides secure administrative access to virtual machines without exposing public IP addresses on the compute resources.

![Architecture diagram](images/architectural_diagram.png)

The spoke VM Scale Set does not have a public IP address. Inbound traffic is handled through an Internal Load Balancer within the compute module, while outbound traffic is routed through a Route Table to Azure Firewall for inspection before reaching the internet.

Administrative access is provided exclusively through Azure Bastion using SSH keys. This keeps the VM Scale Set isolated from direct internet access and avoids exposing public IP addresses on the compute resources.

## Tech Stack

| Category | Technology |
|---|---|
| Compute | Linux VM Scale Set (`Standard_B1s`, Ubuntu 22.04 LTS), 2 instances across zones 1 & 2, `Automatic` upgrade mode |
| Networking | Hub-and-Spoke VNets, VNet Peering (bidirectional, forwarded traffic allowed), NSGs, UDRs |
| Perimeter security | Azure Firewall (`AZFW_VNet`, Standard tier, threat intel mode `Deny`) |
| Access | Azure Bastion (Standard SKU, no public IPs on VMSS) |
| Load balancing | Internal Load Balancer (Standard SKU, TCP health probe on port 80) |
| Monitoring | Log Analytics Workspace, Action Group, VMSS CPU alert |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Security scanning | Checkov, TFLint |
| State backend | Azure Blob Storage (ZRS, TLS 1.2, private, 7-day blob soft delete) |

## Project Structure

```
Hub-and-Spoke-Architecture/
├── .github/
│   └── workflows/
│       ├── bootstrap.yaml         # Checkov, TFLint, plan and apply of the state backend (manual)
│       ├── main_plan.yaml         # Checkov, TFLint, init and plan (runs on PR to main)
│       ├── main_apply.yaml        # init and apply (runs on push to main)
│       └── destroy.yaml           # tears down all resources (manual trigger)
├── bootstrap/
│   ├── main.tf
│   ├── provider.tf
│   └── variables.tf
├── modules/
│   ├── bastion/           # Bastion host + its own public IP
│   ├── compute/           # VMSS + Internal Load Balancer + Custom Script Extension
│   ├── firewall/          # Azure Firewall + firewall policy + rule collections
│   ├── monitor/           # Log Analytics, Action Group, metric alerts
│   ├── network/           # Hub/Spoke VNets, subnets, peering
│   ├── nsg/                # NSG + security rules for the spoke subnet
│   ├── public-ip/         # Public IP for Azure Firewall
│   ├── route_tables/      # UDR forcing spoke egress through the Firewall
│   └── storage/           # Storage account used for Terraform remote state
├── scripts/
│   └── apache.sh
├── backend.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── terraform.tfvars.example
└── README.md
```

## Pipelines

| Pipeline | Trigger | What it does |
|---|---|---|
| `bootstrap` | Manual | Checkov and TFLint scan, then plans and applies the Terraform state backend (`rg-tfstate`, storage account, `tfstate` container) |
| `main_plan` | PR to main (`modules/**`, `*.tf`) | Checkov and TFLint scan, `terraform init`, `terraform plan` |
| `main_apply` | Push to main (`modules/**`, `*.tf`, `scripts/apache.sh`) | `terraform init`, `terraform apply -auto-approve` |
| `destroy` | Manual | Tears down all resources |

### Terraform plan
![terraform-plan](images/terraform_plan.png)

### Terraform apply
![terraform-apply](images/terraform_apply.png)

### Terraform destroy
![terraform-destroy](images/terraform_destroy.png)

## Networking

The environment uses a Hub-and-Spoke design. The hub contains Azure Firewall and Bastion, while the spoke hosts the VM Scale Set. Traffic between the networks is controlled through VNet peering and routing.

## Security

Outbound spoke traffic is routed through Azure Firewall, with rules allowing required HTTP, HTTPS and DNS traffic. NSGs provide additional subnet-level controls, while Azure Bastion is used for administrative access without exposing public IPs on the VMSS.

Terraform state storage is secured with TLS 1.2, public blob access disabled and soft delete enabled. Checkov and TFLint are also used in the CI/CD pipeline to identify security and configuration issues.

## Monitoring

A Log Analytics Workspace and email Action Group are deployed for monitoring. The current alert monitors VMSS CPU usage above 80%.

> **Known gap:** Host encryption is not currently enabled on the VMSS.

## Remote State

Defined in `backend.tf`:

- Resource Group: `rg-tfstate`
- Storage Account: `storage9972007`
- Container: `tfstate`
- State File: `dev.tfstate`

## Azure Resources

| Resource | Type | Purpose |
|---|---|---|
| Hub VNet | Virtual Network | Hosts Firewall, Bastion, and reserved App Gateway subnets |
| Spoke VNet | Virtual Network | Hosts the VMSS |
| Azure Firewall | Firewall | Centralised outbound traffic control |
| Public IP (Firewall) | Public IP | Standard SKU, static allocation, attached to Azure Firewall |
| Azure Bastion | Bastion Host | SSH access with no public IPs on VMSS |
| Public IP (Bastion) | Public IP | Standard SKU, static allocation, attached to Azure Bastion |
| VM Scale Set | Compute | Runs Apache across 2 instances, zones 1 & 2 |
| Internal Load Balancer | Load Balancer | Distributes traffic to the VMSS backend pool |
| Route Table | Routing | Forces spoke egress through Azure Firewall |
| Storage Account | Storage | Terraform remote state backend (ZRS, private, TLS 1.2) |
| Log Analytics Workspace | Monitoring | Centralised logs and metrics |
| Action Group + CPU Alert | Monitoring | Email notification on VMSS CPU > 80% |

### Resource group overview
![Azure resource group](images/resource-group-overview.png)

### VNet peering / topology
![VNet peering](images/vnet-peering.png)

### VM Scale Set overview
![VMSS overview](images/vmss-overview.png)

### Internal Load Balancer
![Internal Load Balancer](images/internal-load-balancer.png)

### Log Analytics metrics
![Log Analytics metrics](images/log-analytics-metrics.png)

### Alert rules
![Alert rules](images/alert-rules.png)

## Deploying the Infrastructure

Bootstrap the Terraform state backend first (one-time, manual):

```bash
cd bootstrap
terraform init
terraform apply
```

Then deploy the main infrastructure — automatically via GitHub Actions (plan on PR, apply on push to main), or manually from the repo root. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values first:

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)" terraform apply -var-file="terraform.tfvars"
```

To destroy:

```bash
terraform destroy
```

The Terraform state storage (`rg-tfstate`) is managed separately by the bootstrap pipeline and is not affected by this command.

## Required GitHub Secrets

| Secret | Description |
|---|---|
| `AZURE_CLIENT_ID` | Service principal client ID |
| `AZURE_CLIENT_SECRET` | Service principal client secret |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |
| `AZURE_TENANT_ID` | Azure tenant ID |
| `TFVARS` | Full contents of `terraform.tfvars`, written to file at pipeline runtime |
| `SSH_PUBLIC_KEY` | Public key injected into the VMSS for Bastion SSH access (passed as `TF_VAR_ssh_public_key`) |

## Author

[Kamaal Bakar](https://www.linkedin.com/in/k-bakar/)