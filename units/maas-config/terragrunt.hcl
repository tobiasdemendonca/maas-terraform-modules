include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  // NOTE: Take note that this source here uses
  // a Git URL instead of a local path.
  //
  // This is because units and stacks are generated
  // as shallow directories when consumed.
  //
  // Assume that a user consuming this unit will exclusively have access
  // to the directory this file is in, and nothing else in this repository.
  source = "git::https://github.com/canonical/maas-terraform-modules.git//modules/maas-config?ref=${values.version}"
}

dependency "maas_deploy" {
  config_path = try(values.maas_deploy_path, null)

  mock_outputs_merge_strategy_with_state = "shallow"

  mock_outputs = {
    maas_api_url = "http://mock-maas"
    maas_api_key = local.mock_maas_api_key
  }
}

dependencies {
  paths = try(values.dependencies, [])
}

locals {
  // Shared with the mock_outputs above, value checked in skip_maas_provider_checks below.
  mock_maas_api_key = "mock:api:key"

  optional_inputs = {
    image_server_url      = try(values.image_server_url, null)
    boot_selections       = try(values.boot_selections, null)
    maas_config           = try(values.maas_config, null)
    package_repositories  = try(values.package_repositories, null)
    tags                  = try(values.tags, null)
    domains               = try(values.domains, null)
    domain_records        = try(values.domain_records, null)
    node_scripts          = try(values.node_scripts, null)
    node_scripts_location = try(values.node_scripts_location, null)
  }
}

inputs = merge({
  // Optional inputs (only passed if defined in the stacks config)
  for k, v in local.optional_inputs :
  k => v
  if v != null
  },
  {
    // Dependent variables
    maas_url = coalesce(try(values.maas_url, null), try(dependency.maas_deploy.outputs.maas_api_url, null))
    maas_key = coalesce(try(values.maas_key, null), try(dependency.maas_deploy.outputs.maas_api_key, null))

    // If someone hasn't specified the MAAS URL, and the maas_deploy dependency is definitely the mocked one,
    // then this is the first time someone is running `plan` as part of a stack that doesn't have a deployed MAAS yet.
    skip_maas_provider_checks = try(values.maas_url, null) == null && try(dependency.maas_deploy.outputs.maas_api_key, null) == local.mock_maas_api_key

    // Required variables
    // (none)
})
