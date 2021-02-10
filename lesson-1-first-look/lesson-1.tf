provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "my_ubuntu" {
    ami           = "ami-0932440befd74cdba"
    instance_type = "t3.micro"

     tags = {
        Name    = "My Ubuntu Server"
        Owner   = "Betman"
        Project = "Terraform lessons"
    }
}

resource "aws_instance" "my_linux" {
    ami           = "ami-0a6dc7529cd559185"
    instance_type = "t3.small"

    tags = {
        Name    = "My Amazon Server"
        Owner   = "Betman"
        Project = "Terraform lessons"
    }
}