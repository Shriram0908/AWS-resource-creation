resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name       = "Terraform-VPC"
    Created_by = "${var.vpc_tag}"
  }
}

resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnet_cidr_block)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr_block[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "private" {
  count                   = "${length(var.private_subnet_cidr_block)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_subnet_cidr_block[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Terraform-IGW"
  }
}

resource "aws_security_group" "windows_access" {
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

resource "aws_security_group" "linux_access" {
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

resource "aws_security_group" "vpc_access" {
  name        = "VPC_Access"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Allows Full access to all server from VPC"

  ingress {
    description = "Allows VPC access"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Terraform VPC Access"
  }
}

resource "aws_security_group" "web_access" {
  name        = "VPC_Access"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Allows web access to Linux server from everywhere"

  ingress {
    description = "Allows web access"
    from_port   = "80"
    to_port     = "80"
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
    Name = "Terraform Web Access"
  }
}

resource "aws_route_table" "route_internet" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "Terraform route table"
  }
}

resource "aws_route_table_association" "internet_access" {
  count          = "${length(var.public_subnet_cidr_block)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.route_internet.id}"
}
