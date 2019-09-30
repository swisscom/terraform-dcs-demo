#=================================================================================================================================
# This sample terraform script shows how terraform can be used to write infrastructure as code in DCS with vCloud Director.
# This is very basic example to create isolated vDC network, Deploy vApp, Deploy VM and attch to the network.
# Check out this link https://www.terraform.io/docs/providers/vcd/index.html for extensive list of supported vCD resources.
#=================================================================================================================================

# vDC Network - Isolated
resource "vcd_network_isolated" "demo_vdc_network_isolated" {
  name         				= "demo_vdc_network_isolated"
  gateway      				= "10.10.10.1"
  dns1                     = "8.8.8.8"

  static_ip_pool {
    start_address 			= "10.10.10.2"
    end_address   			= "10.10.10.254"
  }
}

# Sample vApp
resource "vcd_vapp" "demo_vapp_1" {
  name 						= "demo_vapp_1"
  description 				= "Demo vAPP with demo_vdc_network_isolated network"
  depends_on 				= ["vcd_network_isolated.demo_vdc_network_isolated"] // vApp will be created after network is created.
}

# Sample VM
resource "vcd_vapp_vm" "demo_vm_1" {
  vapp_name 				= "${vcd_vapp.demo_vapp_1.name}"
  name 						= "demo_vm_1"
  catalog_name 				= "${var.vcd_catalog}"
  template_name 			= "${var.vcd_template}"
  memory					= 512 // Momory in MBs
  cpus						= 1 // Number of vCPUs

  power_on 					= "true"

  network {
    type					= "org"
    name					= "${vcd_network_isolated.demo_vdc_network_isolated.name}"
    ip_allocation_mode		= "POOL"
  }

  accept_all_eulas 			= "true"
  depends_on       			= ["vcd_network_isolated.demo_vdc_network_isolated", "vcd_vapp.demo_vapp_1"] // VM will be created after vApp and network are created.
}