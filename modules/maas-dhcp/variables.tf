variable "maas_url" {
  description = "The MAAS URL in the format of: http://127.0.0.1:5240/MAAS"
  type        = string
}

variable "maas_key" {
  description = "The MAAS API key"
  type        = string
}

variable "rack_controller" {
  description = "The hostname of the MAAS rack controller to enable DHCP on"
  type        = string
}

variable "pxe_subnet" {
  description = "The subnet CIDR to serve DHCP from the MAAS rack controller"
  type        = string
}
