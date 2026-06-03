# EC2 Security Group
resource "aws_security_group" "ec2" {
  name        = "workforceconnect-ec2-sg"
  description = "Security group for WorkforceConnect EC2 instance"
  vpc_id      = aws_vpc.main.id

# SSH — your IP only
ingress {
  description = "SSH from engineer IP"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [var.my_ip]
}

# HTTP — public access for the application
ingress {
  description = "HTTP from anywhere"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# HTTPS — public access
ingress {
  description = "HTTPS from anywhere"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# All outbound traffic
egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "workforceconnect-ec2-sg"
 }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "workforceconnect-rds-sg"
  description = "Security group for WorkforceConnect RDS instance"
  vpc_id      = aws_vpc.main.id

# MySQL — from EC2 security group only, never from a CIDR block
ingress {
  description     = "MySQL from EC2 only"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  security_groups = [aws_security_group.ec2.id]
}

egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "workforceconnect-rds-sg"
 }
}
