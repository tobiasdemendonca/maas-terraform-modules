remote_state {
  backend = "local"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${get_parent_terragrunt_dir()}/.terragrunt-local-state/${path_relative_to_include()}/terraform.tfstate"
  }
}

// Configure what repositories to search when you run 'terragrunt catalog' in this directory.
catalog {
  urls = [
    "git::https://github.com/canonical/maas-terraform-modules?ref=main",
  ]
}
