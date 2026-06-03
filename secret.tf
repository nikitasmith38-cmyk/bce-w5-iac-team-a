# Retrieve the secret from AWS Secrets Manager
data "aws_secretsmanager_secret" "db_credentials" {
  name = "workforceconnect/db/credentials"
}

# Fetch the current version of the secret value
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

# Parse the JSON payload and expose individual fields
locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )
 }
