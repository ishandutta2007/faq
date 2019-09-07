#### Web

login page: https://portal.azure.com , web access may be usefull for using shell from Azure [referece](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) Also using PowerShell is a possible that way.


#### Linux

##### instal az client for python3

download and run script from ms [source](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest)

    curl -L https://aka.ms/InstallAzureCli > install.az.bash
    chmod 0755 install.az.bash

other commands to run in case of troubles and multiple python environments

    export PYTHONPATH=
    export LC_ALL=en_US.utf8
    export http_proxy="http://user:pass@host.domain.com:80"
    export https_proxy="$http_proxy" ftp_proxy="$http_proxy"

##### login & looking around

login with browser

    az login

login with user/pass

    az login -u name.surnname@company.com

account information

    az account show
    az account list-locations | grep name

##### create and manage VM

create/remove resource group

    az group create --name myResourceGroup --location eastus
    az group delete --name myResourceGroup --no-wait --yes

check available options

    az vm image list --output table
    az vm image list --offer CentOS --all --output table
    az vm list-sizes --location eastus --output table

create vm

    #az vm create --resource-group myResourceGroup --name myvm01 --image OpenLogic:CentOS:6.5:latest --size Standard_F4s --generate-ssh-keys
    az vm create --resource-group myResourceGroup --name myvm01 --image UbuntuLTS --admin-username azure --generate-ssh-keys

check vm details

    az vm get-instance-view --name myvm01 --resource-group myResourceGroup --query instanceView.statuses[1] --output table
    az vm list-ip-addresses --resource-group myResourceGroup --name myvm01 --output table

managment

    az vm stop --resource-group myResourceGroup --name vmvm01
    az vm start --resource-group myResourceGroup --name vmvm01

resizing

    az vm show --resource-group myResourceGroup --name myvm01 --query hardwareProfile.vmSize
    az vm list-vm-resize-options --resource-group myResourceGroup --name myvm01 --query [].name
    az vm deallocate --resource-group myResourceGroup --name vmvm01
    az vm resize --resource-group myResourceGroup --name vmvm01 --size Standard_GS1
    az vm start --resource-group myResourceGroup --name vmvm01

removing elements

    az vm delete --resource-group myResourceGroup --name myvm01
    az network nic delete --resource-group myResourceGroup --name myvm01VMNic
    az network nsg delete --resource-group myResourceGroup --name myvm01NSG
    az network public-ip delete --resource-group myResourceGroup --name myvm01PublicIP
    az disk delete --resource-group myResourceGroup --name myvm01_disk1_d8bd5adf88e040e2b52838f5a889ea92

set up user for ssh connectivity

    az vm user update --resource-group myResourceGroup --name myvm01 --username azure --password azureX
    az vm user reset-ssh --resource-group myResourceGroup --name myvm01

##### set up app on VM

install web server on VM

    ssh azure@${myVmIp} "sudo apt-get -y update"
    ssh azure@${myVmIp} "sudo apt-get install apache2"
    ssh azure@${myVmIp} "sudo systemctl status apache2"
    ssh azure@${myVmIp} "sudo systemctl start apache2"
    #ssh azure@${myVmIp} "sudo apt-get -y install nginx"

open/close port for http access

    az vm open-port --resource-group myResourceGroup --name myvm01 --port 80
    az network nsg rule show --resource-group myResourceGroup --nsg-name myvm01NSG --name open-port-80
    az network nsg rule delete --resource-group myResourceGroup --nsg-name myvm01NSG --name open-port-80


##### links

 * https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli
 * https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm
 * https://docs.microsoft.com/en-us/azure/virtual-machines/troubleshooting/

#### Windows


##### install AZ PowerShell module

install related module with power shell (as administrator)

    PS > Install-Module -Name Az -AllowClobber
    PS > Connect-AzAccount
    PS > ls ~/.azure

##### links

 * https://azure.microsoft.com/en-us/downloads/
 * https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-2.4.0&viewFallbackFrom=azps-1.2.0
 * https://docs.microsoft.com/en-us/dotnet/framework/install

