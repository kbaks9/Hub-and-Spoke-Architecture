# Azure Hub & Spoke Architecture - Terraform

## Project Goal
Build a production-style Azure Hub & Spoke Architecture using Terraform.

## Implementation Checklist

### Phase 0 - Terraform Bootstrap & Remote State ✅

- [x] Create Terraform bootstrap project
- [x] Create Terraform state Resource Group (`rg-tfstate`)
- [x] Create Terraform state Storage Account (`storage9972007`)
- [x] Create Terraform state Blob Container (`tfstate`)
- [x] Configure AzureRM remote backend
- [x] Store Terraform state remotely in Azure Blob Storage
- [x] Separate Terraform state storage from application resources

Remote State:

- Storage Account: `storage9972007`
- Container: `tfstate`
- State File: `prod.tfstate`

---

### Phase 1 - Core Networking ✅

- [x] Create Resource Group
- [x] Create Hub Virtual Network
- [x] Create Azure Firewall subnet
- [x] Create Azure Bastion subnet
- [x] Create Spoke Virtual Network
- [x] Create Web subnet
- [x] Configure Hub to Spoke VNet peering
- [x] Configure Spoke to Hub VNet peering
- [x] Create Network Security Groups
- [x] Configure NSG security rules

---

### Phase 2 - Compute ✅

- [x] Deploy Linux Virtual Machine Scale Set
- [x] Configure Ubuntu 22.04 LTS
- [x] Deploy 2 VM instances
- [x] Enable Availability Zones
- [x] Configure automatic upgrade mode
- [x] Configure SSH authentication
- [x] Deploy Custom Script Extension
- [x] Install Apache2
- [x] Validate VMSS deployment
- [x] Validate SSH access through Bastion
- [x] Validate Apache response

---

### Phase 3 - Azure Firewall ✅

- [x] Deploy Firewall Public IP
- [x] Configure Standard SKU
- [x] Configure Static allocation
- [x] Deploy Azure Firewall
- [x] Configure Firewall private IP (`10.0.4.4`)
- [x] Configure HTTP outbound rule
- [x] Configure HTTPS outbound rule
- [x] Configure DNS TCP rule
- [x] Configure DNS UDP rule
- [x] Validate outbound traffic through Firewall

---

### Phase 4 - Route Traffic ✅

- [x] Deploy Route Table (`rt-spokes`)
- [x] Configure default route (`0.0.0.0/0`)
- [x] Route traffic through Azure Firewall
- [x] Associate Route Table with Web subnet
- [x] Validate VMSS outbound traffic flow

Traffic Flow:

VMSS → Route Table → Azure Firewall → Internet

---

### Phase 5 - Azure Bastion ✅

- [x] Deploy Azure Bastion
- [x] Deploy Bastion Public IP
- [x] Confirm VMSS has private IP only
- [x] Confirm no VMSS public IP exposure
- [x] Validate SSH access through Bastion

---

### Phase 6 - Internal Load Balancer ✅

- [x] Deploy Internal Azure Load Balancer
- [x] Configure frontend private IP (`10.1.1.4`)
- [x] Create VMSS backend pool
- [x] Configure TCP health probe
- [x] Configure port 80 health check
- [x] Configure load balancing rule
- [x] Validate backend VMSS instances
- [x] Validate Apache through Load Balancer

---

### Phase 7 - High Availability ✅

- [x] Deploy highly available VMSS architecture
- [x] Configure two VM instances
- [x] Enable Availability Zones
- [x] Configure automatic instance management
- [x] Validate application availability

Architecture:

Internal Load Balancer → VM Scale Set → VM Instances

---

### Phase 8 - Monitoring ✅

- [x] Deploy Log Analytics Workspace
- [x] Configure retention period
- [x] Configure Azure Monitor Diagnostic Settings
- [x] Enable Firewall monitoring
- [x] Enable VMSS monitoring
- [x] Validate Firewall metrics
- [x] Validate VM metrics

Validated:

- [x] FirewallHealth
- [x] NetworkRuleHit
- [x] SNATPortUtilization
- [x] CPU monitoring
- [x] Memory monitoring
- [x] Network monitoring
- [x] Disk monitoring

- [x] Create Azure Monitor Alerts for:

Alerts:

- [x] VMSS CPU Percentage > 80%
- [x] VMSS Instances less than 2 (if there are less than 2 instances, send alert, severity 1)

---

### Phase 9 - DevOps / CI-CD 🚧

- [x] Create GitHub Actions folder
- [ongoing] Create GitHub Actions Secrets (Variables)
- [ongoing] Create Terraform plan
- [ ] Create Terraform apply automatically
- [ ] Create Terraform destroy

---

## Project Complete

Completed:

✅ Terraform Bootstrap  
✅ Remote State Backend  
✅ Hub & Spoke Networking  
✅ NSGs  
✅ VM Scale Set  
✅ Apache Deployment  
✅ Azure Firewall  
✅ Routing  
✅ Azure Bastion  
✅ Internal Load Balancer  
✅ High Availability  
✅ Monitoring  

Remaining:

🚧 Azure Monitor Alerts  
🚧 CI/CD Pipeline