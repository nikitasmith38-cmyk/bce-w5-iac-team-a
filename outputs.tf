output "vpc_id" {
  description = "ID of the deployed VPC"
  value       = aws_vpc.main.id

}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.workforceconnect.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.workforceconnect.public_dns
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "Port for the RDS instance"
  value       = aws_db_instance.main.port
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret for DB credentials"
  value       = data.aws_secretsmanager_secret.db_credentials.arn
}
