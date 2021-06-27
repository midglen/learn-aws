#--Input Params
variable "environment_name" {
    type        = string
    description = "Environment Name"
}
variable "vpc_address_space" {
    type        = string
    description = "VPC Address Space (CIDR Format)"
}
variable "bastion_cidr" {
    type        = string
    description = "Bastion Subnet Address Space (CIDR Format)"
}
variable "private_cidr" {
    type        = string
    description = "Private Subnet Address Space (CIDR Format)"
}
variable "wan_edge_ip" {
    type        = string
    description = "Developer Office IP"
}
variable "private_ec2_nodes" {
    type        = number
    description = "Amount of private EC2 nodes to provision"
}

variable "aws_dynamodb_table" {
    type        = string
    default = "tf-remote-state-lock"
}

variable "environment_to_size_map" {
  type =  map
  default = {
    dev     = "small"
    qa      = "medium"
    staging = "large"
    prod    = "xlarge"
  }
}

variable "workspace_to_environment_map" {
  type =  map
  default = {
    dev     = "dev"
    qa      = "qa"
    staging = "staging"
    prod    = "prod"
  }
}

variable "workspace_to_size_map" {
  type =  map
  default = {
    dev     = "small"
    qa      = "medium"
    staging = "large"
    prod    = "xlarge"
  }
}