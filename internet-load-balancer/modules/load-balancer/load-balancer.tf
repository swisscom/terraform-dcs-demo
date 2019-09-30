#=================================================================================================================================
# This module deploys and configure all needed resources for load balancer.
#=================================================================================================================================

# Load balancer config - this is new with VCD provider 2.4.0
# Load balancer app profile
resource "vcd_lb_app_profile" "lb-profile" {
  edge_gateway 				= var.edge_gateway
  name						= "http-app-profile"
  type						= "http"
}

# Load balancer service monitor
resource "vcd_lb_service_monitor" "lb-service-monitor" {
  edge_gateway 				= var.edge_gateway
  name						= "http-http-monitor"
  interval					= "5"
  timeout					= "20"
  max_retries				= "3"
  type						= "http"
  method					= "GET"
}

# Load balancer member pool
resource "vcd_lb_server_pool" "lb-server-pool" {
  edge_gateway 				= var.edge_gateway
  name						= "web-servers-pool"
  description				= "web-servers-pool"
  algorithm					= "round-robin"
  enable_transparency		= "true"
  monitor_id				= "${vcd_lb_service_monitor.lb-service-monitor.id}"

  member {
    condition				= "enabled"
    name					= "web-server-node-1"
    ip_address				= var.member-1-ip
    port					= 80
    monitor_port			= 80
    weight					= 1
  }

  member {
    condition				= "enabled"
    name					= "web-server-node-2"
    ip_address				= var.member-2-ip
    port					= 80
    monitor_port			= 80
    weight					= 1
  }
}

# Load balancer virual server with public IP
resource "vcd_lb_virtual_server" "lb-virtual-server" {
  edge_gateway 				= var.edge_gateway
  name						= "lb-virtual-server"
  ip_address				= var.public-ip-lb
  protocol					= "http"
  port						= 80
  app_profile_id			= "${vcd_lb_app_profile.lb-profile.id}"
  server_pool_id			= "${vcd_lb_server_pool.lb-server-pool.id}"
}