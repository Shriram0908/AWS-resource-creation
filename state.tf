terraform {
  backend "s3" {
    bucket  = "terraform-backed"
    key     = "Terraform/terraform.tfstate"
    profile = "MyPersonalProfile"
    region  = "ap-south-1"
  }
}
