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
  source = "git::git@github.com:tobiasdemendonca/maas-terraform-modules.git//modules/juju-bootstrap?ref=${values.version}"

  before_hook "install_dependencies" {
    commands = ["apply"]
    execute  = [
      "${get_terragrunt_dir()}/scripts/install-dependencies.sh",
      values.juju_channel,
    ]
  }
}

locals {
  optional_inputs = {
    charm_postgresql_channel      = try(values.charm_postgresql_channel, null)
    charm_s3_integrator_channel   = try(values.charm_s3_integrator_channel, null)
  }
}

inputs = merge({
  # Optional inputs (only passed if defined in the stacks config)
  for k, v in local.optional_inputs :
  k => v
  if v != null
},
{
  # Required inputs
  lxd_trust_token = values.lxd_trust_token
  lxd_address     = values.lxd_address
})
