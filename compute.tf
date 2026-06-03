# Key Pair — registers your existing public key
resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = file(pathexpand("~/.ssh/workforceconnect-key.pub")) # Path to your local public key
}

# EC2 Instance
resource "aws_instance" "workforceconnect" {
  ami                         = "ami-0b9064170e32bde34" # Ubuntu 22.04 LTS in us-east-2
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  # Root volume — 20 GB matches your existing instance
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "workforceconnect-app-server"
  }
}
