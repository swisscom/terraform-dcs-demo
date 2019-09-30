#=================================================================================================================================
# This sample terraform script shows how terraform can be used to write infrastructure as code in DCS with vCloud Director.
# This example deploys two web VMs, SNAT for outbound, DNAT for inbound and firewall rules on the edge gateway.
# Fianly, it calls load balancer module to load balance http traffic between two web VMs.
# Check out this link https://www.terraform.io/docs/providers/vcd/index.html for extensive list of supported vCD resources.
#=================================================================================================================================

// Template file for init script to install&configure apache
data "template_file" "init" {
  template = "${file("utils/setup.sh")}"
}

# vDC Network - Routed for Web Tier
resource "vcd_network_routed" "demo_vdc_network_routed_web" {
  name         				= "demo_vdc_network_routed_web"

  edge_gateway 				= "${var.vcd_edgegateway}"
  gateway      				= "10.10.20.1"

  static_ip_pool {
    start_address 			= "10.10.20.2"
    end_address   			= "10.10.20.254"
  }
}

# vDC Network - Routed for App Tier
resource "vcd_network_routed" "demo_vdc_network_routed_app" {
  name         				= "demo_vdc_network_routed_app"

  edge_gateway 				= "${var.vcd_edgegateway}"
  gateway      				= "10.10.30.1"

  static_ip_pool {
    start_address 			= "10.10.30.2"
    end_address   			= "10.10.30.254"
  }
}

# vApp - web; node 1
resource "vcd_vapp" "demo-vapp-web-1" {
  name 						= "demo-vapp-web-1"
  description 				= "Demo vAPP 1 with web-tier network"
  depends_on 				= ["vcd_network_routed.demo_vdc_network_routed_web"]
}

# vApp - web; node 2
resource "vcd_vapp" "demo-vapp-web-2" {
  name 						= "demo-vapp-web-2"
  description 				= "Demo vAPP 2 with web-tier network"
  depends_on 				= ["vcd_network_routed.demo_vdc_network_routed_web"]
}

# VM - web; node 1
resource "vcd_vapp_vm" "demo-web-node-1" {
  vapp_name 				= "${vcd_vapp.demo-vapp-web-1.name}"
  name 						= "demo-web-node-1"
  catalog_name 				= "${var.vcd_catalog}"
  template_name 			= "${var.vcd_template}"
  memory					= 512 // Mommory in MB
  cpus						= 1 // Number of vCPUs

  initscript    			= "${data.template_file.init.rendered}" // Sample guest coustomization script

  power_on 					= "true"

  network {
    type					= "org"
    name					= "${vcd_network_routed.demo_vdc_network_routed_web.name}"
    ip_allocation_mode		= "POOL"
  }
  accept_all_eulas 			= "true"
  depends_on       			= ["vcd_network_routed.demo_vdc_network_routed_web", "vcd_vapp.demo-vapp-web-1"]
}

# VM - web; node 2
resource "vcd_vapp_vm" "demo-web-node-2" {
  vapp_name 				= "${vcd_vapp.demo-vapp-web-2.name}"
  name 						= "demo-web-node-2"
  catalog_name 				= "${var.vcd_catalog}"
  template_name 			= "${var.vcd_template}"
  memory					= 512 // Mommory in MB
  cpus						= 1 // Number of vCPUs

  initscript    			= "${data.template_file.init.rendered}" // Sample guest coustomization script

  power_on 					= "true"

  network {
    type					= "org"
    name					= "${vcd_network_routed.demo_vdc_network_routed_web.name}"
    ip_allocation_mode		= "POOL"
  }

  accept_all_eulas 			= "true"
  depends_on       			= ["vcd_network_routed.demo_vdc_network_routed_web", "vcd_vapp.demo-vapp-web-2"]
}


# SNAT Rule[Private to Public] - Outbound Internet Access for "demo_vdc_network_routed_web"
resource "vcd_snat" "outbound-internet" {
  edge_gateway 				= "${var.vcd_edgegateway}"
  external_ip  				= "${var.vcd_public_ip_lb}" // Public IP
  internal_ip  				= "10.10.20.0/24" // Private IP range
}

# DNAT Rule[Public to Private, port transalation]- Inbound Internet access on specific port
resource "vcd_dnat" "inbount-ssh-web-1" {
  edge_gateway 				= "${var.vcd_edgegateway}"
  external_ip  				= "${var.vcd_public_ip_lb}" // Public IP
  port            			= 2222 // original port
  internal_ip     			= "${vcd_vapp_vm.demo-web-node-1.network.0.ip}" // VM node1 IP
  translated_port 			= 22 // translated port
}

resource "vcd_dnat" "inbount-ssh-web-2" {
  edge_gateway 				= "${var.vcd_edgegateway}"
  external_ip  				= "${var.vcd_public_ip_lb}" // Public IP
  port            			= 22 // original port
  internal_ip     			= "${vcd_vapp_vm.demo-web-node-2.network.0.ip}" // VM node2 IP
  translated_port 			= 22 // translated port
}

# Firewall Rules - allow outbound internet for web-vms
resource "vcd_firewall_rules" "allow-internet-web-vms" {
  edge_gateway 				= "${var.vcd_edgegateway}"
  default_action			= "drop" // default action

  # allow VM node1 to access public IPs
  rule{
    description				= "allow-outbount-internet-web-vm-1"
    policy					= "allow"
    protocol				= "any"
    destination_port		= "any"
    destination_ip			= "external"
    source_port				= "any"
    source_ip				= "${vcd_vapp_vm.demo-web-node-1.network.0.ip}"
  }
  # allow VM node2 to access public IPs
  rule{
    description				= "allow-outbount-internet-web-vm-2"
    policy					= "allow"
    protocol				= "any"
    destination_port		= "any"
    destination_ip			= "external"
    source_port				= "any"
    source_ip				= "${vcd_vapp_vm.demo-web-node-2.network.0.ip}"
  }

  # allow inbound access to load balancer IP
  rule{
    description				= "allow-inbound-web0lb"
    policy					= "allow"
    protocol				= "tcp"
    destination_port		= "80"
    destination_ip			= "${var.vcd_public_ip_lb}" // Public IP assigned to load balancer
    source_port				= "any"
    source_ip				= "external"
  }
}

# Call Load balancer module, this is sample is to explain how the infrastructure can be organized with the help of modules.
module "load_balancer" {
  source        = "./modules/load-balancer" // module directory location
  // variables to be passed to called module
  edge_gateway  = var.vcd_edgegateway
  member-1-ip   = vcd_vapp_vm.demo-web-node-1.network.0.ip
  member-2-ip   = vcd_vapp_vm.demo-web-node-2.network.0.ip
  public-ip-lb  = var.vcd_public_ip_lb
}