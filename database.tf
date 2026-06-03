# RDS Subnet Group — spans two AZs as required by AWS
resource "aws_db_subnet_group" "main" {
  name = "workforceconnect-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

 tags = {
   Name = "workforceconnect-db-subnet-group"
 }
}

# RDS MySQL Instance
resource "aws_db_instance" "main" {
  identifier        = "workforceconnect-db"
  engine            = "MySQL"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  
  db_name  = var.db_name
  username = local.db_creds["admin"]
  password = local.db_creds["Hollins06%40"]

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

# Non-negotiable: RDS must not be reachable from the public internet
publicly_accessible = false

# Prevents accidental deletion during terraform destroy
deletion_protection = false

# Skips final snapshot on destroy — acceptable for training environment
skip_final_snapshot = true

 tags = {
   Name = "workforceconnect-rds"
 }
}
