## Introduction
This example terraform module is to show how terraform code can be organized using [terraform modules](https://www.terraform.io/docs/modules/index.html). 
In this example we define the module for automating load-balancer related operations in [vCloud Director](https://www.terraform.io/docs/providers/vcd/index.html). 

## How to use this Module

This module will be called from **dcs-terraform-internet-loadbalancer-sample.tf**

#### What are these different files 
 
1. **variables.tf**
This file defines the input parameters that are used in this module. 

1. **load-balancer.tf**
This sample module when called from `dcs-terraform-internet-loadbalancer-sample.tf` configure load balancer resources on edge gateway.

