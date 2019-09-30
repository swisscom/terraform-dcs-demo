#========================================================================================================
# In this terraform file, we define all needed variables, these are referenced in terraform scripts.
#========================================================================================================

variable "vcd_url" {
  description = "vCD Url"
}

variable "vcd_user" {
  description = "vCD API username"
}

variable "vcd_pass" {

  description = "vCD API password"

}

variable "vcd_org" {

  description = "Contract Id / PRO-Number"

}

variable "vcd_vdc" {

  description = "Dynamic Data Center"

}

variable "vcd_edgegateway" {

  description = "Edge Gateway"

}

variable "vcd_public_ip_lb" {

  description = "Public IP Address for load balancer"

}

variable "vcd_catalog" {

  description = "Catalog name"

}

variable "vcd_template" {

  description = "vApp template name"

}