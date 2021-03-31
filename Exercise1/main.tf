terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure_rg" {
  name     =  var.rgname
  location =  var.location
}


# Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name                 = var.vnet_name
    address_space        = var.address_space
    location             = var.location
    resource_group_name  = azurerm_resource_group.azure_rg.name
}

# Subnet for virtual machine
resource "azurerm_subnet" "vmsubnet" {
  name                  =  var.subnet_name
  address_prefix        =  var.address_prefix
  virtual_network_name  =  azurerm_virtual_network.vnet.name
  resource_group_name   =  azurerm_resource_group.azure_rg.name
}


# Add a Public IP address
resource "azurerm_public_ip" "vmip" {
    count                  = var.numbercount
    name                   = "vm-ip-${count.index}"
    resource_group_name    =  azurerm_resource_group.azure_rg.name
    allocation_method      = "Static"
    location               = var.location
}

# Add a Network security group
resource "azurerm_network_security_group" "nsgname" {
    name                   = "vm-nsg"
    location               = var.location
    resource_group_name    =  azurerm_resource_group.azure_rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.external_ip
        destination_address_prefix = "*"
  }
   security_rule {
        name                       = "PING"
        priority                   = 105
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "ICMP"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
 }
#data.azurerm_public_ip.vmip.*.ip_address
 security_rule {
        name                       = "Full-access"
        priority                   = 125
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = data.azurerm_public_ip.vmip.0.ip_address
        destination_address_prefix = "*"
 }

security_rule {
        name                       = "Full-access-1"
        priority                   = 135
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = data.azurerm_public_ip.vmip.1.ip_address
        destination_address_prefix = "*"
 }

}



#Associate NSG with  subnet
resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
    subnet_id                    = azurerm_subnet.vmsubnet.id
    network_security_group_id    = azurerm_network_security_group.nsgname.id
}

# NIC with Public IP Address
resource "azurerm_network_interface" "terranic" {
    count                  = var.numbercount
    name                   = "vm-nic-${count.index}"
    location               = var.location
    resource_group_name    =  azurerm_resource_group.azure_rg.name

    ip_configuration {
        name                          = "external"
        subnet_id                     = azurerm_subnet.vmsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = element(azurerm_public_ip.vmip.*.id, count.index)
  }

}


#Data Disk for Virtual Machine
#resource "azurerm_managed_disk" "datadisk" {
# count                = var.numbercount
# name                 = "datadisk_existing_${count.index}"
# location             = var.location
# resource_group_name  = var.rgname
# storage_account_type = "Standard_LRS"
# create_option        = "Empty"
# disk_size_gb         = "50"
#}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


#Aure Virtual machine
resource "azurerm_linux_virtual_machine" "terravm" {
    name                  = "vm-stg-${count.index}"
    location              = var.location
    resource_group_name   = azurerm_resource_group.azure_rg.name
    count                 = var.numbercount
    network_interface_ids = [element(azurerm_network_interface.terranic.*.id, count.index)]
    size               = "Standard_B1ms"
    admin_username      = "azureuser"


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }



        admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

}


// Dynamic public ip address will be got after it's assigned to a vm
data "azurerm_public_ip" "vmip" {
  count               = var.numbercount
  name                = azurerm_public_ip.vmip[count.index].name
  resource_group_name = azurerm_resource_group.azure_rg.name
}

output "tls_private_key" { value = tls_private_key.example_ssh.private_key_pem }

output "vm-public-ip" {
description = "The actual ip address allocated for the resource"
#value =  element(azurerm_public_ip.vmip.*.address, count.index)
value       = data.azurerm_public_ip.vmip.*.ip_address
}

resource "local_file" "public_ip" {
    content = <<-EOT
    %{ for ip in data.azurerm_public_ip.vmip.*.ip_address ~}
    ${ip}
    %{ endfor ~}
  EOT
    filename = "public_ip.txt"
}

resource "local_file" "private_key" {
    content  =  tls_private_key.example_ssh.private_key_pem
    filename = "private_key.pem"
}