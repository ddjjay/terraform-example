terraform {
  backend "local" {
    path = "./terraform.tfstate.d/fortis-ca-central-1-ec2-web-app-dev/terraform.tfstate"
  }
}