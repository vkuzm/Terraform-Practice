
provider "aws" {
    region = var.region
} 

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Enviroment"]} server IP"
  })
  
  /*
  tags = {
    Name    = "Server IP"
    Owner   = "John Snow"
    Project = "Phenix"
  }
  */
}

resource "aws_instance" "my_server" {
    ami                    = data.aws_ami.latest_ubuntu.id
    instance_type          = var.instance_type
    vpc_security_group_ids = [aws_security_group.dynamic_security_group.id]
    monitoring             = var.enable_detailed_monitoring

    tags = merge(var.common_tags, {
      Name    = "${var.common_tags["Enviroment"]} server built by Terraform",
      Region  = var.region
    })

    /*
    tags = {
      Name    = "Server built by Terraform"
      Owner   = "John Snow"
      Project = "Phenix"
      Region = var.region
    }
    */
}

resource "aws_security_group" "dynamic_security_group" {
  name          = "Dynamic Security Group"
  description   = "My first security group"

  dynamic "ingress" {
    for_each = var.ingress_allow_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.ingress_protocol_type
      cidr_blocks = var.ingress_cidr_blocks
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags  = {
    Name = "Dynamic security group"
  }
}