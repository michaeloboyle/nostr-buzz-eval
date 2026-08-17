variable "region" {
  description = "Cloud region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for resources."
  type        = string
  default     = "nostr-buzz"
}

variable "instance_type" {
  description = "VM size. A small instance is enough to evaluate."
  type        = string
  default     = "t3.small"
}

variable "disk_gb" {
  description = "Root disk size in GB (event store + blobs live here)."
  type        = number
  default     = 25
}

variable "relay_port" {
  description = "Port the relay listens on (wss)."
  type        = number
  default     = 7000
}

variable "ssh_key_name" {
  description = "Name of an existing EC2 key pair for SSH access."
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH. Lock this to your IP; do not leave it open."
  type        = list(string)
  default     = []
}

variable "relay_allowed_cidrs" {
  description = "CIDRs allowed to reach the relay. Restrict for a private test."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
