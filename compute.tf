# Key Pair — registers your existing public key
resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = file(pathexpand("~/.ssh/workforceconnect-key.pub")) # Path to your local public key
}

# EC2 Instance
resource "aws_instance" "workforceconnect-app-server" {
  ami           = "ami-0eab37cfdc33e8e65"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id 
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name      = aws_key_pair.main.key_name

# Assigns a public IP — required for SSH and HTTP access
associate_public_ip_address = true

# Root volume — 20 GB matches your existing instance
root_block_device {
  volume_size = 20
  volume_type = "gp3"
  encrypted   = true
}

 tags = {
   Name = "workforceconnect-ec2"
 }
}
