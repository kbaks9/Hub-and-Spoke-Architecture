resource "azurerm_linux_virtual_machine_scale_set" "spoke1_vmss" {
  name                            = "spoke1-vmss"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = "Standard_B1s"
  instances                       = 2
  zones                           = ["1", "2"]
  admin_username                  = "adminuser"
  disable_password_authentication = true
  upgrade_mode                    = "Automatic"
  encryption_at_host_enabled      = false

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
    #file("~/.ssh/id_rsa.pub") # Just created it 05/07/26
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "spoke1-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.vm_subnet_id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.lb_backend_pool.id
      ]
    }
  }
}

data "local_file" "apache_script" {
  filename = "${path.root}/scripts/apache.sh"
}

# Allows custom scripts
resource "azurerm_virtual_machine_scale_set_extension" "apache" {
  name                         = "apache-install"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.spoke1_vmss.id

  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROT
{
  "script": "${base64encode(data.local_file.apache_script.content)}"
}
PROT
}

resource "azurerm_lb" "lb_internal" {
  name                = "spoke1-internal-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "vmss-backend-pool"
  loadbalancer_id = azurerm_lb.lb_internal.id
}

resource "azurerm_lb_probe" "lb_app_probe" {
  name            = "app-health-probe"
  loadbalancer_id = azurerm_lb.lb_internal.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "app-rule"
  loadbalancer_id                = azurerm_lb.lb_internal.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "internal"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_app_probe.id
}
