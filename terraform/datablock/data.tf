# Step 1: Provider configuration
provider "aws" {
  region = "ap-south-1"
}

# Step 2: Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-02521d90e7410d9f0"  # Update with valid AMI ID in your region
  instance_type = "t2.micro"
  tags = {
    Name = "my-ec2-instance"
  }
}

# Step 3: Use data block to fetch the same EC2 instance
data "aws_instance" "fetched_instance" {
  instance_id = aws_instance.example.id
  depends_on  = [aws_instance.example] # Ensures data block waits for creation
}

# Step 4: Output attributes from the data block
output "fetched_instance_public_ip" {
  value = data.aws_instance.fetched_instance.public_ip
}

output "fetched_instance_ami" {
  value = data.aws_instance.fetched_instance.ami
}
