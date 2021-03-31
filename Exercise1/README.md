Using Terraform to provision multiple VMs in Azure Cloud.

Terraform will provsion the New Resource Group, Vnet, Subnet, Public IP, Network Interface, Network SG and Virtual Machines.


Files Usage:

main.tf -> Main terraform configuration file to provision the infrastructure.

Variable.tf -> contains variable defention and default vaue details required to run  main terraform file.

utilization.sh -> Bash script used to login into the Terraform provisioned vms and ouput the Resource information like CPU, Disk and Network Listening Ports.



Terrafrom Workflow:

$ terraform init

Run the terraform int command to initialize the Terraform working directory and automatically downloads any of the providers required plugin into .terrform directory.

$ terraform plan 

Run the terraform plan command is used to create an execution plan. Terraform determines what actions are necessary to achieve the desired state specified in the configuration files. This is a dry run and shows which actions will be made.

$ terraform apply -var="external_ip=x.x.x.x" -auto-approve

Note "Need to replace x.x.x.x with your Server Public IP address to whitelist in Security group to connect the VM prvosioned by Terraform"


Run the terraform apply command to deploy the resources. By default, it will also prompt for confirmation that you want to apply those changes. Since we are automating the deployment we are adding auto-approve argument to not prompt for confirmation.



Terraform apply will output the private_key and Public_IPs into a file in the terraform working directory.


Bash Script WorkFlow:

After terraform complete its task, Please run the Bash script file "utilization.sh".

Script will look for the Public_ip and private_key file to connect the VMs and output the Resource utilization of all the vms provisioned by Terraform.


$ ./utilization.sh 



