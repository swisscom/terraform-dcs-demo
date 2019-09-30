## Introduction
This repo contains sample infrastructure as code snippets to deploy, maintain and manage infrastructure on DCS using  Terraform [vCloud Director](https://www.terraform.io/docs/providers/vcd/index.html) provider.

## How to use this Module

* Make sure that you have DCS contract and have your Contract Number/Pro-Number ready.

* Create vCloud Director API User from DCS Self Service Portal.

* Create Dynamic Data Center from DCS Self Service Portal.

* Create Internet Access with Edge Gateway from DCS Self Service Portal.

#### What are these different files 
1. **config-values.tfvars** 
This file is to pass configuration values to the terraform apply/destroy commands instead of passing values manually. 
**Edit this file by exchanging the values as per your DCS environment setup**.
 
1. **main.tf** 
This file is to define terraform provider for [vCloud Director](https://github.com/terraform-providers/terraform-provider-vcd).

1. **variables.tf**
This file defines all the needed variables that are referenced in this sample terraform script. 

1. **dcs-terraform-internet-loadbalancer-sample.tf**
This sample terraform script shows how terraform can be used to write infrastructure as code in DCS with vCloud Director. This particular example would automate the creation of **vDC Network Routed**, two web **vAPPs/VMs**, **install apache** on these VMs, configure needed **SNAT, DNAT** rules, **Firewall rules** and finally calling **load-balancer module** to configure **load balancer** for load balancing HTTP traffic between two web VMs.

 

#### Quick Start  

1. Open your shell change directory to `\terraform-dcs-demo\internet-load-balancer` and execute `terraform init` it will download vCloud Director provider and initialize terraform.
1. Run `terraform validate` to make sure the configuration is valid.
1. Run `terraform apply -var-file="../config-values.tfvars"` to apply the changes required to reach the desired state of the configuration. This will start deploying resources in your DCS contract.
1. Run `terraform destroy -var-file="../config-values.tfvars"` Infrastructure managed by Terraform will be destroyed. This will ask for confirmation before destroying. This will start destroying resources managed by Terraform in your DCS contract.
