# Key Pair — registers your existing public key
resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = file(pathexpand("~/.ssh/workforceconnect-key.pub")) # Path to your local public key
}

# EC2 Instance
resource "aws_instance" "workforceconnect-app-server" {
  ami           = "ami-0eab37cfdc33e8e65"
  instance_type = "t3.micro"
  subnet_id     = "subnet-0388f6a18fe7661bf"
  vpc_security_group_ids = [sg-063e7d215c2df6855]
  key_name      = "workforceconnect-key"

# Assigns a public IP — required for SSH and HTTP access
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
