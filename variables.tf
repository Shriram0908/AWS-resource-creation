variable "vpc_cidr_block" {
  description = "VPC CIDR block range"
  default     = "10.0.0.0/16"
}

variable "vpc_tag" {
  description = "VPC tags"
  default     = "Terraform"
}

variable "aws_access_key" {
  description = "Access key"
}

variable "aws_secret_key" {
  description = "Secret access key"
}

variable "aws_region" {
  description = "Region to deploy"
  default     = "ap-south-1"
}

variable "private_subnet_cidr_block" {
  description = "Private subnet"
  type        = "list"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr_block" {
  description = "Public subnet"
  type        = "list"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "sg_windows_rdp" {
  default = "3389"
}

variable "sg_linux_rdp" {
  default = "22"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "Temp1"
}
