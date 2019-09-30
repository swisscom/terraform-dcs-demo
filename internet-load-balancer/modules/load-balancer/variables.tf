#========================================================================================================
# In this terraform file, we define all needed variables inside the module.
#========================================================================================================
variable "edge_gateway" {
  description = "This variable is used for resources created by this module."
  type        = string
}

variable "member-1-ip" {
  description = "This variable is used for resources created by this module."
  type        = string
}

variable "member-2-ip" {
  description = "This variable is used for resources created by this module."
  type        = string
}

variable "public-ip-lb" {
  description = "This variable is used for resources created by this module."
  type        = string
}