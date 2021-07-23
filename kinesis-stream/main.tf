terraform {
  backend "s3" {
    bucket = "terraform-state-ig"
    key = "aws-data-architect-bootcamp/kinesis/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-state"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_kinesis_stream" "stock_data_stream" {
  name = "stock-data-stream"
  shard_count = 1
  retention_period = 24
}
