provider "maas" {
  api_key = var.maas_key
  api_url = var.maas_url
}

data "maas_rack_controller" "dhcp_rack" {
  hostname = var.rack_controller
}

data "maas_subnet" "pxe" {
  cidr = var.pxe_subnet
}

data "maas_fabric" "pxe_fabric" {
  name = data.maas_subnet.pxe.fabric
}

resource "maas_subnet_ip_range" "dhcp_range" {
  subnet   = data.maas_subnet.pxe.id
  type     = "dynamic"
  start_ip = cidrhost(data.maas_subnet.pxe.cidr, 99)
  end_ip   = cidrhost(data.maas_subnet.pxe.cidr, 254)
}

resource "maas_vlan_dhcp" "dhcp_enabled" {
  fabric                  = data.maas_fabric.pxe_fabric.id
  vlan                    = data.maas_subnet.pxe.vid
  primary_rack_controller = data.maas_rack_controller.dhcp_rack.id
  ip_ranges               = [maas_subnet_ip_range.dhcp_range.id]
}

# resource "maas_machine" "test3" {
#   power_type = "lxd"
#   power_parameters = jsonencode({
#     project       = "default",
#     certificate   = "...",
#     power_address = "10.10.0.1",
#     key           = "..."
#     instance_name = "test-machine-3",
#   })
#   hostname        = "tf-test-machine"
#   # pxe_mac_address = "00:16:3e:04:2a:c2"
#   pxe_mac_address = "00:16:3e:e6:81:a1"
# }

# resource "maas_machine" "test2" {
#   power_type = "lxd"
#   power_parameters = jsonencode({
#     project       = "default",
#     certificate   = "...",
#     power_address = "10.10.0.1",
#     key           = "..."
#     instance_name = "test-machine-2",
#   })
#   hostname        = "tf-test-machine-2"
#   pxe_mac_address = "00:16:3e:5e:c6:82"
# # }

# resource "maas_machine" "test3" {
#   power_type = "lxd"
#   power_parameters = jsonencode({
#     project       = "default",
#     certificate   = "...",
#     power_address = "10.10.0.1",
#     key           = "..."
#     instance_name = "test-machine-3",
#   })
#   hostname        = "tf-test-machine"
#   pxe_mac_address = "00:16:3e:e6:81:a1"
# }
