## PUT TERRAFORM CLOUD BLOCK HERE!  ##

terraform {
  
  cloud { 
    
    organization = "TerraformLearning120" 

    workspaces { 
      name = "tf-cloud-test" 
    } 
  } 
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-west-2"
}

# Data source to get the latest Ubuntu 22.04 LTS AMI for us-west-2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "tc_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-0ced54783d659b91c" # sandbox-2-vpc subnet in us-west-2a
  associate_public_ip_address = true

  tags = {
    Name = "TC-triggered-instance"
  }
}