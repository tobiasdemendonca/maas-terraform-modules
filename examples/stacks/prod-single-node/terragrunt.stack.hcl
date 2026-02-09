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
    
    // Juju snap channel to install if not already present on the system, before running juju-bootstrap.
    juju_channel = "3.6/stable"

    // Variables for OpenTofu/Terraform modules
    lxd_trust_token = get_env("LXD_TRUST_TOKEN")
    lxd_address = "https://10.10.0.1:8443"
    lxd_project = "charmed-maas"
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

  }
}
