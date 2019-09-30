# DCS Infrastructure as code with Terraform 

## Introduction
This repo contains sample infrastructure as code snippets to deploy, maintain and manage infrastructure on DCS using  Terraform [vCloud Director](https://www.terraform.io/docs/providers/vcd/index.html) provider.

[Terraform](https://www.terraform.io/) enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.

[Download](https://www.terraform.io/downloads.html) Terraform based on your operating system to execute terraform code and plans.

Install Terraform by unzipping it and moving it to a directory included in your system's [PATH](https://superuser.com/questions/284342/what-are-path-and-other-environment-variables-and-how-can-i-set-or-use-them).

## How to use this Module

* Make sure that you have DCS contract and have your Contract Number/Pro-Number ready.

* Create vCloud Director API User from DCS Self Service Portal.

* Create Dynamic Data Center from DCS Self Service Portal.

#### What are these different files 
1. **config-values.tfvars** 
This file is to pass configuration values to the terraform apply/destroy commands instead of passing values manually. 
**Edit this file by exchanging the values as per your DCS environment setup**.
 
1. **main.tf** 
This file is to define terraform provider for [vCloud Director](https://github.com/terraform-providers/terraform-provider-vcd).

1. **variables.tf**
This file defines all the needed variables that are referenced in this sample terraform script. 

1. **dcs-terraform-basic-sample.tf**
This sample terraform script shows how terraform can be used to write infrastructure as code in DCS with vCloud Director. This particular example will create a vDC Network,vApp and VM attached to the network. 

#### Quick Start  

1. Open your shell change directory to `\terraform-dcs-demo` and execute `terraform init` it will download vCloud Director provider and initialize terraform.
1. Run `terraform validate` to make sure the configuration is valid.
1. Run `terraform apply -var-file="config-values.tfvars"` to apply the changes required to reach the desired state of the configuration. This will start deploying resources in your DCS contract.
1. Run `terraform destroy -var-file="config-values.tfvars"` Infrastructure managed by Terraform will be destroyed. This will ask for confirmation before destroying. This will start destroying resources managed by Terraform in your DCS contract.




    
## References

[Terraform](https://www.terraform.io/)

[Download Terraform](https://www.terraform.io/downloads.html)

[vCloud Director Terraform Provider](https://github.com/terraform-providers/terraform-provider-vcd)

[Getting Started with Terraform](https://learn.hashicorp.com/terraform/getting-started/install)
