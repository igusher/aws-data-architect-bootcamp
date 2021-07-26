terraform {
  backend "s3" {
    bucket = "terraform-state-ig"
    key = "aws-data-architect-bootcamp/redshift/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-state"
    encrypt = true
  }
}
