#==========================================================================================================================================
# This file holds values that are assigned to the variables, which will be referenced in terraform scripts.
# The following command shows how this file can be used while applying terraform plan.
# sample command : terraform apply -var-file="config-values.tfvars"
#==========================================================================================================================================

vcd_user = "api_vcd_XXXXXXXXXX" // vCD Api Username, this can be orderd in DCS Self-Service Portal

vcd_pass = "XXXXXXXXXXXXXXXXXXXX" // vCD Api User Password

vcd_org = "PRO-XXXXXXXXX" // Contract Id or PRO-Number

vcd_vdc = "XXXXXXXXXXXXX" // Dynamic Data Center, this can be orderd in DCS Self-Service Portal

vcd_url = "https://vcd-pod-{{alpha|bravo|charlie}}.swisscomcloud.com/api" // vCD URL, Example : https://vcd-pod-charlie.swisscomcloud.com/api

vcd_catalog = "Public Catalog" // Catalog name, "Public Catalog" is where you can find Swisscom enterprise OS templates.

vcd_template = "RHEL7-U6-vmware-dcs-20190701.16" // vApp template name, this will be used to create the VMs from template in vCD.

vcd_edgegateway = "PRO-XXXXXXXXX_XXXXXXXXXX" // Edge Gateway for Internet Access, this can be orderd in DCS Self-Service Portal

vcd_public_ip_lb = "X.X.X.X" // DCS Public IP for load balancer.