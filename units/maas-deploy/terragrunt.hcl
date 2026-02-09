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
  source = "git::git@github.com:canonical/maas-terraform-modules.git//modules/maas-deploy?ref=${values.version}"
}

generate "provider_juju_mock" {
  path      = "provider_juju_mock.tf"
  if_exists = "overwrite"
  contents  = <<EOF
# Mock Juju provider configuration for planning
# The real credentials come from the Juju CLI after juju-bootstrap runs
provider "juju" {
# These values allow init/plan to work, but won't actually connect
controller_addresses = try(get_env("JUJU_CONTROLLER_ADDRESSES"), "127.0.0.1")
client_id            = try(get_env("JUJU_USERNAME"), "mock-user")
client_secret        = try(get_env("JUJU_PASSWORD"), "mock-pass")
ca_certificate       = try(get_env("JUJU_CA_CERT"), "-----BEGIN CERTIFICATE-----\nMIIEEzCCAnugAwIBAgIVAKE4tp5+qQbUJtiEhMvpQOqPcjlRMA0GCSqGSIb3DQEB\nCwUAMCExDTALBgNVBAoTBEp1anUxEDAOBgNVBAMTB2p1anUtY2EwHhcNMjYwMjAy\nMTcxNjEzWhcNMzYwMjAyMTcyMTEzWjAhMQ0wCwYDVQQKEwRKdWp1MRAwDgYDVQQD\nEwdqdWp1LWNhMIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKCAYEArsr8HO/g\nMn/hAZxmf/4eS/sHQUU0NizzrDLWIM3vHoQHTFdSMFzC5/vDGi/meiTmEZGvyazR\nwvhXMhcTlBulCSlI7KufYZcjOmnxnqkn54eUYvZespBkdeGFnvGkugWm+l51YY/a\n9MWcMb/fo/fenVy5pZxLg6z01JWOMKNnygR2R1+xzQVCaGiNw9ADoGMXqUWG3HVf\nETW6pXIx3G1VcE2NOHVIqQ5S0hZ2yBC8+X51axung52A5Dk/irIgEfVlnh7QpqKC\nYZkL/Uj6+r/IhUodjsltl3rIU8eOjetxdt0ieC/NeefEynyq0v3XY8KKdwXVtR0c\ncxud83oTjeYz/PU/b7Re8kFNg2eRGVZRTer7MhmTqc5KInQyY1ahUs6ziAI9NPzO\nW6fxf+GoX/4Fo6k68/xyGC2wdmacrd5tWBIC6vH2iykQ0xSMfNyRaj8S0phpDMZn\nx0Vc443JW+h3IIxrksAnNX/4Hi7mfgR9KGkn/oQhKBzERiXSkssXEDbbAgMBAAGj\nQjBAMA4GA1UdDwEB/wQEAwICpDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQX\nplfhxEElCdc2JyYLxRJ6FqJqyjANBgkqhkiG9w0BAQsFAAOCAYEAfg4R6vDnMw5e\nKT/BwE4loqjUTlxv+8bIOhAwYmmo+kkXQ/WIO0oqEIj20xYd2TX1OfYMYdxJSOKW\nRRLjWygCMZqqmjqf5HAYl3gZelgbVJWTZ14u4dv55CJv9zOR6FcmFnLdMoryk+pP\nQFFGO7DnPVV2bIXHUCh/HRdrnJ2uaD6qP2yhYbr65t2z3gW4Gy1Pd2U8XsUL8eMP\nIB7AArYfeuM2Ne7XgEeMzGlZ/vnkT0G62mgW4K/r85Oah4rGWNZe9lxt/fBHG/BX\nYKGgOUlCGXBdcdh2ago2bVzlgV9xctpxTHCfO6VOoeskCW+rMd7y9wxWTBGu3mzI\npY2BkA4RGJMG4cztgXDUbhl7TXEAy+4GyHPpwRXr1AExdDZRjAVUOd4tk1rEYYhR\nUfsY7gd1Gc3ldRRv71I5QYuvF4P/juqSthZxWhtYTLrutO6y0FLe60UNTCtNBnA+\nxfHnh4MMY42J8B1KafUUu40Zf1y2DLr7ylCdYFhN8rT9ib+u683L\n-----END CERTIFICATE-----")
}
EOF
}

dependency "juju_bootstrap" {
  config_path = values.juju_bootstrap_path

  mock_outputs = {
    juju_cloud = "mock-cloud-name"
    controller = "controller-name"
  }

}

locals {
  optional_inputs = {
      // --- Environment ---
    juju_cloud_region = try(values.juju_cloud_region, null)
    lxd_project        = try(values.lxd_project, null)
    model_config       = try(values.model_config, null)
    path_to_ssh_key    = try(values.path_to_ssh_key, null)

    // --- Machines and constraints ---
    maas_constraints     = try(values.maas_constraints, null)
    postgres_constraints = try(values.postgres_constraints, null)
    enable_postgres_ha = try(values.enable_postgres_ha, null)
    enable_maas_ha     = try(values.enable_maas_ha, null)
    ubuntu_version     = try(values.ubuntu_version, null)

    // --- Workload: PostgreSQL ---
    charm_postgresql_channel   = try(values.charm_postgresql_channel, null)
    charm_postgresql_revision  = try(values.charm_postgresql_revision, null)
    charm_postgresql_config    = try(values.charm_postgresql_config, null)

    // --- Workload: MAAS ---
    charm_maas_region_channel  = try(values.charm_maas_region_channel, null)
    charm_maas_region_revision = try(values.charm_maas_region_revision, null)
    charm_maas_region_config   = try(values.charm_maas_region_config, null)

    //--- MAAS Admin configuration ---
    admin_username   = try(values.admin_username, null)
    admin_password   = try(values.admin_password, null)
    admin_email      = try(values.admin_email, null)
    admin_ssh_import = try(values.admin_ssh_import, null)

    // --- External integrations (backup/s3) ---
    enable_backup                = try(values.enable_backup, null)
    charm_s3_integrator_channel  = try(values.charm_s3_integrator_channel, null)
    charm_s3_integrator_revision = try(values.charm_s3_integrator_revision, null)
    charm_s3_integrator_config   = try(values.charm_s3_integrator_config, null)
    s3_ca_chain_file_path        = try(values.s3_ca_chain_file_path, null)
    s3_access_key                = try(values.s3_access_key, null)
    s3_secret_key                = try(values.s3_secret_key, null)
    s3_bucket_postgresql         = try(values.s3_bucket_postgresql, null)
    s3_path_postgresql           = try(values.s3_path_postgresql, null)
    s3_bucket_maas               = try(values.s3_bucket_maas, null)
    s3_path_maas                 = try(values.s3_path_maas, null)
  }
}

inputs = merge({
  # Optional inputs (only passed if defined in the stacks config)
  for k, v in local.optional_inputs :
  k => v
  if v != null
},
{
  // --- Dependencies ---
  juju_cloud_name   = dependency.juju_bootstrap.outputs.juju_cloud
})
