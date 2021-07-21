terraform {
  backend "s3" {
    bucket = "terraform-state-ig"
    key = "aws-data-architect-bootcamp/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-state"
    encrypt = true
  }
}


provider "aws" {
  region = "us-east-2"
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  name = "my-first-kinesis-firehose-stream"
  destination = "s3"

  s3_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.kinesis-destination-bucket.arn
    buffer_size        = 1
    buffer_interval    = 60
    cloudwatch_logging_options {
      enabled = false
    }
  }

}

resource "aws_s3_bucket" "kinesis-destination-bucket" {
  bucket = "kinesis-destination-bucket-ig"
  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = false
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-read-only-policy-attachment" {
    role = "firehose_test_role"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

