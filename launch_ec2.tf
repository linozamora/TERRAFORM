terraform {

  required_providers {
    aws = {
    source  = "hashicorp/aws"

    version = "~> 3.27"

    }
  }


  required_version = ">= 0.14.9"

}

provider "aws" {

  region                = var.aws_region
  shared_credentials_file = "/home/lin0x/.aws/credentials"
  profile               = "lin0x"

}

   
resource "aws_instance" "soporte-sai" {

  #vpc_id  = "vpc-0c7a0ced3d81f0ec3"
  subnet_id = "subnet-04e5e6fbaeaa35ffe"
  ami = "ami-02f762206f896bff9"
  instance_type = var.instance_type
  key_name = "SAI-QA"
 vpc_security_group_ids = [aws_security_group.soporte-sai-sg.id]
associate_public_ip_address = false
  root_block_device {
    volume_type = "gp2"
    volume_size = "15"
    delete_on_termination = false

}
 user_data = <<EOF

#!/bin/bash

sudo apt-get update

sudo apt-get upgrade -y

sudo apt-get install git nginx -y

cd /var/www/

git clone https://github.com/TalentumLAB/soporte.osticket.git

mkdir /tmp/ssm

cd /tmp/ssm

wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

sudo dpkg -i amazon-ssm-agent.deb

sudo systemctl status amazon-ssm-agent

sudo systemctl enable amazon-ssm-agent

sudo systemctl start amazon-ssm-agent

EOF

  tags = {
    Name = "osticket"
  }
}

