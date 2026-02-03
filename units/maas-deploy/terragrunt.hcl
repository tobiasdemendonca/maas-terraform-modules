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
  source = "git::git@github.com:skatsaounis/infrastructure-catalog.git//modules/maas-setup?ref=${values.version}"
}

dependency "juju_bootstrap" {
  config_path = values.juju_bootstrap_path

  mock_outputs = {
    juju_cloud = "mock-cloud-name"
  }
}

inputs = {
  // Dependencies
  juju_cloud_name    = dependency.juju_bootstrap.outputs.juju_cloud

  // General inputs
  ubuntu_version     = try(values.ubuntu_version, null)
  enable_postgres_ha = try(values.enable_postgres_ha, null)
  enable_maas_ha     = try(values.enable_maas_ha, null)
  lxd_project        = try(values.lxd_project, null)

  // PostgreSQL configuration
  charm_postgresql_channel   = try(values.charm_postgresql_channel, null)
  charm_postgresql_revision  = try(values.charm_postgresql_revision, null)
  charm_postgresql_config    = try(values.charm_postgresql_config, null)
  max_connections            = try(values.max_connections, null)
  max_connections_per_region = try(values.max_connections_per_region, null)

  // MAAS Region configuration
  charm_maas_region_channel  = try(values.charm_maas_region_channel, null)
  charm_maas_region_revision = try(values.charm_maas_region_revision, null)
  charm_maas_region_config   = try(values.charm_maas_region_config, null)

  // MAAS Agent configuration
  charm_maas_agent_channel  = try(values.charm_maas_agent_channel, null)
  charm_maas_agent_revision = try(values.charm_maas_agent_revision, null)
  charm_maas_agent_config   = try(values.charm_maas_agent_config, null)

  // MAAS Admin configuration
  admin_username   = try(values.admin_username, null)
  admin_password   = try(values.admin_password, null)
  admin_email      = try(values.admin_email, null)
  admin_ssh_import = try(values.admin_ssh_import, null)
}
