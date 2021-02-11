provider "aws" {
    region = "eu-central-1"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_amazon_linux" {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "web" {
  name          = "WebServer Security Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web server security group"
  }
}

resource "aws_elb" "web" {
    name               = "Webserver-HA-ELB"
    availability_zones = [
        data.aws_availability_zones.available.names[0], 
        data.aws_availability_zones.available.names[1]
    ]
    security_groups    = [aws_security_group.web.id]

    listener {
        lb_port           = 80
        lb_protocol       = "http"
        instance_port     = 80
        instance_protocol = "http"
    }

    health_check {
        healthy_threshold    = 2
        unhealthy_threshold  = 2
        timeout              = 3
        target               = "HTTP:80/"
        interval             = 10
    }

    tags = {
        Name = "Webserver-Highly-Available-ELB"
    }
}

resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_launch_configuration" "web" {
    //name          = "Webserver-Highly-Available"
    name_prefix     = "Webserver-Highly-Available-"
    image_id        = data.aws_ami.latest_amazon_linux.id
    instance_type   = "t3.micro"
    security_groups = [aws_security_group.web.id]
    user_data       = file("user_data.sh")

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "web" {
    name                 = "ASG-${aws_launch_configuration.web.name}"
    launch_configuration = aws_launch_configuration.web.name
    min_size             = 2
    max_size             = 2
    min_elb_capacity     = 2
    health_check_type    = "ELB"
    vpc_zone_identifier  = [
        aws_default_subnet.default_az1.id, 
        aws_default_subnet.default_az2.id
    ]
    load_balancers       = [aws_elb.web.name]

    dynamic "tag" {
        for_each = {
            Name   = "Web Server in ASG"
            Owner  = "John Snow"
            TAGKEY = "TAGVALUE"
        } 
        
        content {
            key                  = tag.key
            value                = tag.value
            propagate_at_launch = true
        }
    }

    lifecycle {
        create_before_destroy = true
    }
}

output "web_loadbalancer_url" {
    value = aws_elb.web.dns_name
}