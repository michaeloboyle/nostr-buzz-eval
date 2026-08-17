# Minimal Terraform example: provision a VM running a self-hosted Buzz/Nostr relay.
#
# TEMPLATE. Applying this provisions BILLABLE cloud resources (an EC2 instance,
# storage, and egress). Cost is the operator's, not this repo's. Review before apply.
#
# The portable part is deploy/cloud-init.yaml; this file only wires it to a VM.
# To use a different cloud, swap the provider + instance/firewall resources and keep
# passing cloud-init.yaml as user_data. GCP / DigitalOcean / Hetzner equivalents are
# a small edit — see deploy/terraform/README.md.

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Latest Ubuntu 22.04 LTS AMI (Canonical).
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "relay" {
  name        = "${var.name}-relay"
  description = "Buzz/Nostr relay: SSH + wss relay port"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "Relay (wss)"
    from_port   = var.relay_port
    to_port     = var.relay_port
    protocol    = "tcp"
    cidr_blocks = var.relay_allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-relay"
  }
}

resource "aws_instance" "relay" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.relay.id]
  user_data              = file("${path.module}/../cloud-init.yaml")

  root_block_device {
    volume_size = var.disk_gb
  }

  tags = {
    Name = "${var.name}-relay"
  }
}
