# My unit 
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_terragrunt_dir()}"
}

dependency "maas_deploy" {
  config_path = values.maas_deploy_path

  mock_outputs_merge_strategy_with_state = "shallow"

  mock_outputs = {
    maas_api_url = "http://mock-maas"
    maas_api_key = "mock-password"
  }
}

inputs = {
  maas_url        = dependency.maas_deploy.outputs.maas_api_url
  maas_key        = dependency.maas_deploy.outputs.maas_api_key
  rack_controller = values.rack_controller
  pxe_subnet      = values.pxe_subnet
}
