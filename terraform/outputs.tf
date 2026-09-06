output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "nip_io_hostname" {
  description = "nip.io hostname derived from the public IP, for Ingress rules"
  value       = "${aws_instance.main.public_ip}.nip.io"
}

output "ssh_command" {
  description = "Quick SSH command to connect"
  value       = "ssh -i ./${var.key_name}.pem ubuntu@${aws_instance.main.public_ip}"
}