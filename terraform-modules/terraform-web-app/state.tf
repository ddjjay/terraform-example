
# This will eventually be handled by terragrunt
terraform {
  backend "local" {
    path = "./terraform.tfstate.d/ca-central-1-ec2-web-app-dev/terraform.tfstate"
  }
}
