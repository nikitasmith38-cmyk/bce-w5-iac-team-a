# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "workforceconnect-ec2-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
   }]
 })
}

# Policy allowing EC2 to retrieve the specific secret only
resource "aws_iam_policy" "secrets_access" {
  name = "workforceconnect-secrets-access"
  description = "Allows EC2 to retrieve WorkforceConnect DB credentials
from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect  = "Allow"
      Action  = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource =
"arn:aws:secretsmanager:${var.aws_region}:*:secret:workforceconnect/db/cre
dentials*"
    }]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ec2_secrets" {
  role = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

# Instance profile — the mechanism that attaches a role to an EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "workforceconnect-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
