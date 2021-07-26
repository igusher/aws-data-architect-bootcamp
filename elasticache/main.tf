/*
resource "aws_elasticache_cluster" "redis" {
  node_type = "cache.t2.micro"
  engine = "redis"
  cluster_id = "standalone-redis"
  num_cache_nodes = 1
}
*/

resource "aws_elasticache_replication_group" "redis_cluster" {
  automatic_failover_enabled    = true
  replication_group_id          = "redis-rep-group-1"
  replication_group_description = "My first redis replication group"
  node_type                     = "cache.t2.micro"
  parameter_group_name          = "default.redis6.x.cluster.on"
  port                          = 6379

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups = 2
  }
}

output "address" {
  value = aws_elasticache_replication_group.redis_cluster.configuration_endpoint_address
  description = "Redis cluster address"
}

resource "aws_instance" "example" {
  ami = "ami-00399ec92321828f5"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
             #!/bin/bash
             echo "Hello World" > index.html
             apt install
             nohup busybox httpd -f -p ${local.web_server_port} &
             EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "ec2-instance-sg"

  ingress {
    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

locals {
  http_port = 80
  web_server_port = 8080
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

output "public_ip" {
  value = aws_instance.example.public_ip
  description = "Public IP address of the web server"
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "elasticache-full-access-attachment" {
    role = "test_role"
    policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}
