resource "aws_msk_cluster" "my_kafka" {
  cluster_name = "my-kafka-cluster"
  number_of_broker_nodes = 3
  kafka_version = "2.8.0"

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    ebs_volume_size = 1
    client_subnets = [
      aws_subnet.subnet_az0.id,
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id,
    ]
    security_groups = [aws_security_group.kafka.id]
  }

  logging_info {
    broker_logs {
      firehose {
        enabled = true
        delivery_stream = aws_kinesis_firehose_delivery_stream.kinesis_firehose_stream.name
      }
      s3 {
        enabled = true
        bucket  = aws_s3_bucket.kafka_logs_bucket.id
        prefix  = "logs/direct-msk-"
      }
    }
  }
}

resource "aws_iam_role" "kafka_role" {
  name = "kafka_role"

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

resource "aws_iam_role_policy_attachment" "s3-full-access-for-kafka" {
    role = aws_iam_role.kafka_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "kinesis-firehose-full-access-for_kafka" {
    role = aws_iam_role.kafka_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
}
