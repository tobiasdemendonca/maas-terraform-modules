 unit "juju_bootstrap" {
  // You'll typically want to pin this to a particular version of your catalog repo.
  // e.g.
  // source = "git::git@github.com:canonical/maas-terraform-modules.git//units/juju-bootstrap?ref=v0.1.0"
  source = "../../../units/juju-bootstrap"

  path = "juju-bootstrap"

  values = {
    // This version here is used as the version passed down to the unit
    // to use when fetching the OpenTofu/Terraform module.
    version = "main"

    // The Juju snap channel to install on the system, before running juju-bootstrap.
    juju_channel = "3.6/stable"

    // Required variables
    // You will have to add
    lxd_trust_token = get_env("LXD_TRUST_TOKEN")
    lxd_address = "https://10.10.0.1:8443"

    // Optional variables
    // lxd_project = "charmed-maas"
    // model_defaults = {}
    // cloud_name = "maas-cloud"
  }
}

unit "maas_deploy" {
  // You'll typically want to pin this to a particular version of your catalog repo.
  // e.g.
  // source = "git::git@github.com:canonical/maas-terraform-modules.git//units/maas-deploy?ref=v0.1.0"
  source = "../../../units/maas-deploy"

  path = "maas-deploy"

  values = {
    // This version here is used as the version passed down to the unit
    // to use when fetching the OpenTofu/Terraform module.
    version = "main"

    // Dependencies
    juju_bootstrap_path = "../juju-bootstrap"

    // Required variables
    // (none)

    // Optional variables
    // Uncomment and complete to customize. Defaults are shown where defined in variables.tf.
    // lxd_project        = "charmed-maas"
    // model_config       = ...
    // path_to_ssh_key    = ...

    // -- Machines and constraints
    // maas_constraints     = ...
    // postgres_constraints = ...
    // enable_postgres_ha   = ...
    // enable_maas_ha       = ...
    // ubuntu_version       = ...

    // -- Workload: PostgreSQL
    // charm_postgresql_channel   = ...
    // charm_postgresql_revision  = ...
    // charm_postgresql_config    = ...

    // -- Workload: MAAS
    // charm_maas_region_channel  = ...
    // charm_maas_region_revision = ...
    charm_maas_region_config   = {
      enable_rack_mode = true
    }

    // -- MAAS Admin configuration
    // admin_username   = ...
    // admin_password   = ...
    // admin_email      = ...
    // admin_ssh_import = ...

    // -- External integrations (backup/s3)
    // enable_backup                = ...
    // charm_s3_integrator_channel  = ...
    // charm_s3_integrator_revision = ...
    // charm_s3_integrator_config   = ...
    // s3_ca_chain_file_path        = ...
    // s3_access_key                = ...
    // s3_secret_key                = ...
    // s3_bucket_postgresql         = ...
    // s3_path_postgresql           = ...
    // s3_bucket_maas               = ...
    // s3_path_maas                 = ...
  }
}
