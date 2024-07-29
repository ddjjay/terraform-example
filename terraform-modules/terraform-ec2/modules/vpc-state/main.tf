# We grab the state from a local state, 
## This should be the s3 backend when in prod

data "terraform_remote_state" "vpc_module" {
  backend = "local"

  config = {
    path = var.backend_config_path
  }
}