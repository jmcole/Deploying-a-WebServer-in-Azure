# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Use Azure CLI to log into Azure from bash
```
az login
```
2. Utilize Packer and the server.json file to create a server image.
```
packer build server.json
```
3. Use Terraform to deploy WebApp
   * Initialize Terraform
     ```
     terraform init
     ```
   * Create execution plan
     ```
     terraform plan -out solution.plan
     ```
   * Check configuration
     ```
     terraform validate
     ```
   * Execute the plan
     ```
     terraform apply
     ```
4. Check deployment in Azure

### Customization

The [variables](variables.tf) file contains variables that can be used to customize the deployment. Azure policy for the subscription requires tags. The tags variable can be used to change tags to identify the resources used for a particular deployment. 
![Azure Tag Policy](https://github.com/jmcole/Deploying-a-WebServer-in-Azure/blob/main/images/az-list2.PNG)
In addition, the "Client" variable will attach a prefix that can be used to further tie resources to a particular customer or department. Names for Resource groups and images can be modified through the [variables](variables.tf) file. The Azure location and the number of instances created can also be modified.

### Output

Azure Created Resources
![Azure Resources](https://github.com/jmcole/Deploying-a-WebServer-in-Azure/blob/main/images/all_resources.PNG)


Terraform Output from Terraform Apply
```
cole_@DESKTOP-EEBHS2F MINGW64 ~/OneDrive/Desktop/ND082/nd082-Azure-Cloud-Devops-Starter-Code/C1 - Azure Infrastructure Operations/project/starter_files (master)
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are  
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_availability_set.vmss will be created
  + resource "azurerm_availability_set" "vmss" {
      + id                           = (known after apply)
      + location                     = "eastus"
      + managed                      = true
      + name                         = "JMC-aset"
      + platform_fault_domain_count  = 3
      + platform_update_domain_count = 5
      + resource_group_name          = "JMC_resource_group"
      + tags                         = {
          + "Client" = "JMC"
        }
    }

  # azurerm_lb.vmss will be created
  + resource "azurerm_lb" "vmss" {
      + id                   = (known after apply)
      + location             = "eastus"
      + name                 = "JMC_vmss-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "JMC_resource_group"
      + sku                  = "Basic"
      + tags                 = {
          + "Client" = "JMC"
        }

      + frontend_ip_configuration {
          + id                            = (known after apply)
          + inbound_nat_rules             = (known after apply)
          + load_balancer_rules           = (known after apply)
          + name                          = "JMC_PublicIPAddress"
          + outbound_rules                = (known after apply)
          + private_ip_address            = (known after apply)
          + private_ip_address_allocation = (known after apply)
          + private_ip_address_version    = "IPv4"
          + public_ip_address_id          = (known after apply)
          + public_ip_prefix_id           = (known after apply)
          + subnet_id                     = (known after apply)
        }
    }

  # azurerm_lb_backend_address_pool.bpepool will be created
  + resource "azurerm_lb_backend_address_pool" "bpepool" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "JMC_BackEndAddressPool"
      + outbound_rules            = (known after apply)
      + resource_group_name       = (known after apply)
    }

  # azurerm_lb_probe.vmss will be created
  + resource "azurerm_lb_probe" "vmss" {
      + id                  = (known after apply)
      + interval_in_seconds = 15
      + load_balancer_rules = (known after apply)
      + loadbalancer_id     = (known after apply)
      + name                = "JMC_ssh-running-probe"
      + number_of_probes    = 2
      + port                = 80
      + protocol            = (known after apply)
      + resource_group_name = "JMC_resource_group"
    }

  # azurerm_lb_rule.lbnatrule will be created
  + resource "azurerm_lb_rule" "lbnatrule" {
      + backend_address_pool_id        = (known after apply)
      + backend_port                   = 80
      + disable_outbound_snat          = false
      + enable_floating_ip             = false
      + frontend_ip_configuration_id   = (known after apply)
      + frontend_ip_configuration_name = "JMC_PublicIPAddress"
      + frontend_port                  = 80
      + id                             = (known after apply)
      + idle_timeout_in_minutes        = (known after apply)
      + load_distribution              = (known after apply)
      + loadbalancer_id                = (known after apply)
      + name                           = "http"
      + probe_id                       = (known after apply)
      + protocol                       = "Tcp"
      + resource_group_name            = "JMC_resource_group"
    }

  # azurerm_network_interface.jumpbox will be created
  + resource "azurerm_network_interface" "jumpbox" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "JMC_jumpbox-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "JMC_resource_group"
      + tags                          = {
          + "Client" = "JMC"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + name                          = "IPConfiguration"
          + primary                       = (known after apply)
          + private_ip_address            = (known after apply)
          + private_ip_address_allocation = "dynamic"
          + private_ip_address_version    = "IPv4"
          + public_ip_address_id          = (known after apply)
          + subnet_id                     = (known after apply)
        }
    }

  # azurerm_network_security_group.vmss will be created
  + resource "azurerm_network_security_group" "vmss" {
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "JMC_acceptanceTestSecurityGroup"
      + resource_group_name = "JMC_resource_group"
      + security_rule       = [
          + {
              + access                                     = "Deny"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "test123"
              + priority                                   = 100
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "Internet"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
      + tags                = {
          + "Client" = "JMC"
        }
    }

  # azurerm_public_ip.jumpbox will be created
  + resource "azurerm_public_ip" "jumpbox" {
      + allocation_method       = "Static"
      + domain_name_label       = (known after apply)
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "eastus"
      + name                    = "JMC_jumpbox-public-ip"
      + resource_group_name     = "JMC_resource_group"
      + sku                     = "Basic"
      + tags                    = {
          + "Client" = "JMC"
        }
    }

  # azurerm_public_ip.vmss will be created
  + resource "azurerm_public_ip" "vmss" {
      + allocation_method       = "Static"
      + domain_name_label       = (known after apply)
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "eastus"
      + name                    = "JMC_vmss-public-ip"
      + resource_group_name     = "JMC_resource_group"
      + sku                     = "Basic"
      + tags                    = {
          + "Client" = "JMC"
        }
    }

  # azurerm_resource_group.vmss will be created
  + resource "azurerm_resource_group" "vmss" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "JMC_resource_group"
      + tags     = {
          + "Client" = "JMC"
        }
    }

  # azurerm_subnet.vmss will be created
  + resource "azurerm_subnet" "vmss" {
      + address_prefix                                 = (known after apply)
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "JMC_vmss-subnet"
      + resource_group_name                            = "JMC_resource_group"
      + virtual_network_name                           = "JMC_vmss-vnet"
    }

  # azurerm_virtual_machine.jumpbox will be created
  + resource "azurerm_virtual_machine" "jumpbox" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "eastus"
      + name                             = "JMC-jumpbox"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "JMC_resource_group"
      + tags                             = {
          + "Client" = "JMC"
        }
      + vm_size                          = "Standard_DS1_v2"

      + identity {
          + identity_ids = (known after apply)
          + principal_id = (known after apply)
          + type         = (known after apply)
        }

      + os_profile {
          + admin_password = (sensitive value)
          + admin_username = "azureuser"
          + computer_name  = "JMC-jumpbox"
          + custom_data    = (known after apply)
        }

      + os_profile_linux_config {
          + disable_password_authentication = true

          + ssh_keys {
              + key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC35EkhS/+ILrhcCHNzAlYx1kGHOMX2COVglDV1pIINSNZd15+s5jaFzm+ETFzx/mVfCWbqu4GudrxqLdrf/Gr/QpNDzJd3pPDVc4V8JBhswuj7IrT8bTfstXCx+LprKJBCfkkV9menhJKMzPMLQLh5E+dkpqAsVnVGqN1Os04uj9EtnpIs7nNXT5rOegV68WqVRkwromg1cMD2moic9tUbdIeqEHsKxdNefwGGqdcJN+Z97uR/qD9EnmLZ0Fqwh5VIjKVwYhiWTIjKYJZfLbjMF/fM0MIs826Pfd2PaE4mG6iKxYan7XttuQyhlK7M3AnYr47yvliJNwFnONAQq0tb"
              + path     = "/home/azureuser/.ssh/authorized_keys"
            }
        }

      + storage_data_disk {
          + caching                   = (known after apply)
          + create_option             = (known after apply)
          + disk_size_gb              = (known after apply)
          + lun                       = (known after apply)
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = (known after apply)
          + name                      = (known after apply)
          + vhd_uri                   = (known after apply)
          + write_accelerator_enabled = (known after apply)
        }

      + storage_image_reference {
          + offer     = "UbuntuServer"
          + publisher = "Canonical"
          + sku       = "16.04-LTS"
          + version   = "latest"
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = (known after apply)
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Standard_LRS"
          + name                      = "jumpbox-osdisk"
          + os_type                   = (known after apply)
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine_scale_set.vmss will be created
  + resource "azurerm_virtual_machine_scale_set" "vmss" {
      + automatic_os_upgrade   = false
      + id                     = (known after apply)
      + license_type           = (known after apply)
      + location               = "eastus"
      + name                   = "JMC_vmscaleset"
      + overprovision          = true
      + resource_group_name    = "JMC_resource_group"
      + single_placement_group = true
      + tags                   = {
          + "Client" = "JMC"
        }
      + upgrade_policy_mode    = "Manual"

      + identity {
          + identity_ids = (known after apply)
          + principal_id = (known after apply)
          + type         = (known after apply)
        }

      + network_profile {
          + ip_forwarding = false
          + name          = "terraformnetworkprofile"
          + primary       = true

          + ip_configuration {
              + application_gateway_backend_address_pool_ids = []
              + application_security_group_ids               = []
              + load_balancer_backend_address_pool_ids       = (known after apply)
              + load_balancer_inbound_nat_rules_ids          = (known after apply)
              + name                                         = "IPConfiguration"
              + primary                                      = true
              + subnet_id                                    = (known after apply)
            }
        }

      + os_profile {
          + admin_password       = (sensitive value)
          + admin_username       = "azureuser"
          + computer_name_prefix = "vmlab"
        }

      + os_profile_linux_config {
          + disable_password_authentication = true

          + ssh_keys {
              + key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC35EkhS/+ILrhcCHNzAlYx1kGHOMX2COVglDV1pIINSNZd15+s5jaFzm+ETFzx/mVfCWbqu4GudrxqLdrf/Gr/QpNDzJd3pPDVc4V8JBhswuj7IrT8bTfstXCx+LprKJBCfkkV9menhJKMzPMLQLh5E+dkpqAsVnVGqN1Os04uj9EtnpIs7nNXT5rOegV68WqVRkwromg1cMD2moic9tUbdIeqEHsKxdNefwGGqdcJN+Z97uR/qD9EnmLZ0Fqwh5VIjKVwYhiWTIjKYJZfLbjMF/fM0MIs826Pfd2PaE4mG6iKxYan7XttuQyhlK7M3AnYr47yvliJNwFnONAQq0tb"
              + path     = "/home/azureuser/.ssh/authorized_keys"
            }
        }

      + sku {
          + capacity = 2
          + name     = "Standard_DS1_v2"
          + tier     = "Standard"
        }

      + storage_profile_data_disk {
          + caching           = "ReadWrite"
          + create_option     = "Empty"
          + disk_size_gb      = 10
          + lun               = 0
          + managed_disk_type = (known after apply)
        }

      + storage_profile_image_reference {
          + id = "/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/myPackerImages/providers/Microsoft.Compute/images/myPackerImage"
        }

      + storage_profile_os_disk {
          + caching           = "ReadWrite"
          + create_option     = "FromImage"
          + managed_disk_type = "Standard_LRS"
          + vhd_containers    = []
        }
    }

  # azurerm_virtual_network.vmss will be created
  + resource "azurerm_virtual_network" "vmss" {
      + address_space         = [
          + "10.0.0.0/16",
        ]
      + guid                  = (known after apply)
      + id                    = (known after apply)
      + location              = "eastus"
      + name                  = "JMC_vmss-vnet"
      + resource_group_name   = "JMC_resource_group"
      + subnet                = (known after apply)
      + tags                  = {
          + "Client" = "JMC"
        }
      + vm_protection_enabled = false
    }

  # random_string.fqdn will be created
  + resource "random_string" "fqdn" {
      + id          = (known after apply)
      + length      = 6
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = false
      + result      = (known after apply)
      + special     = false
      + upper       = false
    }

Plan: 15 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + jumpbox_public_ip      = (known after apply)
  + jumpbox_public_ip_fqdn = (known after apply)
  + vmss_public_ip_fqdn    = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_string.fqdn: Creating...
random_string.fqdn: Creation complete after 0s [id=hqansx]
azurerm_resource_group.vmss: Creating...
azurerm_resource_group.vmss: Creation complete after 1s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group]
azurerm_virtual_network.vmss: Creating...
azurerm_availability_set.vmss: Creating...
azurerm_public_ip.vmss: Creating...
azurerm_public_ip.jumpbox: Creating...
azurerm_network_security_group.vmss: Creating...
azurerm_availability_set.vmss: Creation complete after 2s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Compute/availabilitySets/JMC-aset]  
azurerm_virtual_network.vmss: Creation complete after 5s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/virtualNetworks/JMC_vmss-vnet]
azurerm_subnet.vmss: Creating...
azurerm_network_security_group.vmss: Creation complete after 5s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/networkSecurityGroups/JMC_acceptanceTestSecurityGroup]
azurerm_public_ip.vmss: Creation complete after 6s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/publicIPAddresses/JMC_vmss-public-ip]
azurerm_lb.vmss: Creating...
azurerm_public_ip.jumpbox: Creation complete after 6s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/publicIPAddresses/JMC_jumpbox-public-ip]
azurerm_lb.vmss: Creation complete after 1s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/loadBalancers/JMC_vmss-lb]
azurerm_lb_backend_address_pool.bpepool: Creating...
azurerm_lb_probe.vmss: Creating...
azurerm_lb_probe.vmss: Creation complete after 1s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/loadBalancers/JMC_vmss-lb/probes/JMC_ssh-running-probe]
azurerm_lb_backend_address_pool.bpepool: Creation complete after 2s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/loadBalancers/JMC_vmss-lb/backendAddressPools/JMC_BackEndAddressPool]
azurerm_lb_rule.lbnatrule: Creating...
azurerm_subnet.vmss: Creation complete after 5s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/virtualNetworks/JMC_vmss-vnet/subnets/JMC_vmss-subnet]
azurerm_network_interface.jumpbox: Creating...
azurerm_virtual_machine_scale_set.vmss: Creating...
azurerm_lb_rule.lbnatrule: Creation complete after 0s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/loadBalancers/JMC_vmss-lb/loadBalancingRules/http]
azurerm_network_interface.jumpbox: Creation complete after 2s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Network/networkInterfaces/JMC_jumpbox-nic]
azurerm_virtual_machine.jumpbox: Creating...
azurerm_virtual_machine_scale_set.vmss: Still creating... [10s elapsed]
azurerm_virtual_machine.jumpbox: Still creating... [10s elapsed]
azurerm_virtual_machine_scale_set.vmss: Still creating... [20s elapsed]
azurerm_virtual_machine.jumpbox: Still creating... [20s elapsed]
azurerm_virtual_machine_scale_set.vmss: Still creating... [30s elapsed]
azurerm_virtual_machine.jumpbox: Still creating... [30s elapsed]
azurerm_virtual_machine_scale_set.vmss: Still creating... [40s elapsed]
azurerm_virtual_machine.jumpbox: Still creating... [40s elapsed]
azurerm_virtual_machine_scale_set.vmss: Still creating... [50s elapsed]
azurerm_virtual_machine.jumpbox: Creation complete after 48s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Compute/virtualMachines/JMC-jumpbox]
azurerm_virtual_machine_scale_set.vmss: Still creating... [1m0s elapsed]
azurerm_virtual_machine_scale_set.vmss: Still creating... [1m10s elapsed]
azurerm_virtual_machine_scale_set.vmss: Creation complete after 1m13s [id=/subscriptions/bb154300-88af-4fe8-b226-1ca08d7c53d4/resourceGroups/JMC_resource_group/providers/Microsoft.Compute/virtualMachineScaleSets/JMC_vmscaleset]

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

jumpbox_public_ip = "20.115.114.94"
jumpbox_public_ip_fqdn = "hqansx-ssh.eastus.cloudapp.azure.com"
vmss_public_ip_fqdn = "hqansx.eastus.cloudapp.azure.com"

```

