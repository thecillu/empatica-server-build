# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-central-1"
}

variable "ecr_name" {
  default     = "empatica-registry"
}

variable "github_url" {
  default = "https://github.com/thecillu/empatica-server.git"
}


variable "app_port" {
  default = 80
}

variable "lb_port" {
  default = 80
}


