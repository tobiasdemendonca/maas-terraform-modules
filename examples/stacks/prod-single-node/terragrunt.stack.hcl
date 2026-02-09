locals {
  name = "charmed-maas-dev"

  # NOTE: This is only defined here to make this example simple.
  # Don't actually store credentials for your DB in plain text!
  db_username = "admin"
  db_password = "password"
}

unit "juju_bootstrap" {
  // You'll typically want to pin this to a particular version of your catalog repo.
  // e.g.
  // source = "git::git@github.com:skatsaounis/infrastructure-catalog.git//units/juju-bootstrap?ref=v0.1.0"
  source = "../../../units/juju-bootstrap"

  path = "juju-bootstrap"

  values = {
    // This version here is used as the version passed down to the unit
    // to use when fetching the OpenTofu/Terraform module.
    version = "feat/terragrunt-units-bootstrap"
    juju_channel = "3.6/stable"
    // Variables for OpenTofu/Terraform modules
    lxd_trust_token = get_env("LXD_TRUST_TOKEN")
    lxd_address = "https://10.10.0.1:8443"
    lxd_project = "anvil-training"
  }
}

unit "maas_deploy" {
  // You'll typically want to pin this to a particular version of your catalog repo.
  // e.g.
  // source = "git::git@github.com:skatsaounis/infrastructure-catalog.git//units/maas-setup?ref=v0.1.0"
  source = "../../../units/maas-deploy"

  path = "maas-deploy"

  values = {
    // This version here is used as the version passed down to the unit
    // to use when fetching the OpenTofu/Terraform module.
    version = "feat/terragrunt-units-bootstrap"

    // Dependencies
    juju_bootstrap_path = "../juju-bootstrap"

  }
}

# unit "maas_config" {
#   // You'll typically want to pin this to a particular version of your catalog repo.
#   // e.g.
#   // source = "git::git@github.com:skatsaounis/infrastructure-catalog.git//units/maas-setup?ref=v0.1.0"
#   source = "../../../units/maas-config"
  
#   path = "maas-config"

#   values = {
#     // This version here is used as the version passed down to the unit
#     // to use when fetching the OpenTofu/Terraform module.
#     version = "feat/terragrunt-units-bootstrap"

#     // Dependencies
#     maas_setup_path = "../maas_deploy"
#   }
# }
