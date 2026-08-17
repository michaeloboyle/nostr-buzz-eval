output "relay_public_ip" {
  description = "Public IP of the relay VM."
  value       = aws_instance.relay.public_ip
}

output "relay_endpoint" {
  description = "wss endpoint to point Buzz clients/agents at."
  value       = "wss://${aws_instance.relay.public_ip}:${var.relay_port}"
}

output "ssh" {
  description = "SSH into the VM to inspect the stack."
  value       = "ssh ubuntu@${aws_instance.relay.public_ip}"
}
