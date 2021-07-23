resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_stream" {
  name = "kinesis-firehose-stream"

  destination = "s3"
  s3_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.kafka_logs_bucket.arn
    prefix = "logs/firehose-"
    buffer_size        = 1
    buffer_interval    = 60
    cloudwatch_logging_options {
      enabled = false
    }
  }
}

resource "aws_s3_bucket" "kafka_logs_bucket" {
  bucket = "kafka-logs-ig"
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

resource "aws_iam_role_policy_attachment" "s3-full-access-policy-attachment" {
    role = aws_iam_role.firehose_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "kinesis-full-access-policy-attachment" {
    role = aws_iam_role.firehose_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}
