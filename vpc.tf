resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name       = "Terraform-VPC"
    Created_by = "${var.vpc_tag}"
  }
}

resource "aws_subnet" "Public" {
  count                   = "${length(var.public_subnet_cidr_block)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr_block[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "Private" {
  count                   = "${length(var.private_subnet_cidr_block)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_subnet_cidr_block[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Terraform-IGW"
  }
}

resource "aws_security_group" "Windows_Access" {
  name        = "Windows_Access"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Allows RDP access to Windows server from everywhere"

  ingress {
    description = "Allows RDP access"
    from_port   = "${var.sg_windows_rdp}"
    to_port     = "${var.sg_windows_rdp}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Terraform Windows Access"
  }
}

resource "aws_security_group" "Linux_Access" {
  name        = "Linux_Access"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Allows SSH access to Linux server from everywhere"

  ingress {
    description = "Allows SSH access"
    from_port   = "${var.sg_linux_rdp}"
    to_port     = "${var.sg_linux_rdp}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Terraform Linux Access"
  }
}

resource "aws_route_table" "route_internet" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW.id}"
  }

  tags {
    Name = "Terraform route table"
  }
}
