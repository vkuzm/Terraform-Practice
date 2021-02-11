variable "region" {
  description = "Enter region to deploy server"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Enter instance type"
  type        = string
  default     = "t3.micro"
}

variable "ingress_allow_ports" {
  description = "Enter list of ports to open"
  type        = list
  default     = ["80", "443", "22"]
}

variable "ingress_protocol_type" {
  description = "Enter protocol type"
  type        = string
  default     = "tcp"
}

variable "ingress_cidr_blocks" {
  description = "Enter list of cidr blocks"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "enable_detailed_monitoring" {
  type        = bool
  default     = "true"
}

variable "common_tags" {
  type      = map
  default   =  {
    Owner      = "John Snow"
    Project    = "Phenix"
    Enviroment = "development"
  }
}